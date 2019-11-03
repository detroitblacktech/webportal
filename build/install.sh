#!/usr/bin/env bash

# Currently supports: CentOS

JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz"
BUILD_DIR=$(pwd)
OS_INFO=$(cat /etc/*release 2>/dev/null)
OS_VER=$(echo "$OS_INFO" | grep -i "^VERSION_ID=" | sed 's/VERSION_ID=//gI; s/\"//g')

# install dependencies
yum -y install epel-release wget git
cd /tmp && wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install epel-release-latest-7.noarch.rpm
yum -y install python34 python34-mysql python34-jinja2.noarch python34-pip.noarch

# install oracle java
cd /opt && wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" ${JDK_URL}
tar -xzf jdk*.tar* && rm -f jdk*.tar* && cd jdk*
alternatives --install /usr/bin/java java /opt/jdk*/bin/java 2
alternatives --config java <<< '2' && echo ""
alternatives --install /usr/bin/jar jar /opt/jdk*/bin/jar 2
alternatives --config jar <<< '2' && echo ""
alternatives --install /usr/bin/javac javac /opt/jdk*/bin/javac 2
alternatives --config javac <<< '2' && echo ""
mkdir -p /etc/profile.d
echo '#!/usr/bin/env bash' >> /etc/profile.d/java.sh
echo '' >> /etc/profile.d/java.sh
echo 'JAVA_HOME=$(ls -l /opt | grep -ioP -m 1 "jdk-.*" | head -1)' >> /etc/profile.d/java.sh
echo 'JRE_HOME="${JAVA_HOME}/jre"' >> /etc/profile.d/java.sh
echo 'PATH="${PATH}:${JAVA_HOME}/bin:${JRE_HOME}/bin:$PATH"' >> /etc/profile.d/java.sh
echo 'export JAVA_HOME' >> /etc/profile.d/java.sh
echo 'export JRE_HOME' >> /etc/profile.d/java.sh
echo 'export PATH' >> /etc/profile.d/java.sh
source /etc/profile && source ~/.bash_profile && source ~/.bash_login && source ~/.profile

# install mysql
if [[ "$OS_VER" == "7" ]]; then
    rpm -ivh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
    systemctl start mysqld
    systemctl enable mysqld
    yum -y install mysql-community-server
elif [[ "$OS_VER" == "6" ]]; then
    rpm -ivh https://dev.mysql.com/get/mysql57-community-release-el6-11.noarch.rpm
    service mysqld start
    chkconfig mysqld on
    yum -y install mysql-community-server
elif [[ "$OS_VER" == "5" ]]; then
    rpm -ivh https://dev.mysql.com/get/mysql57-community-release-el5-8.noarch.rpm
    service mysqld start
    chkconfig mysqld on
    yum -y install mysql-community-server
fi

# install python modules
python3.4 -m pip install -r ${BUILD_DIR}/requirements.txt

exit 0