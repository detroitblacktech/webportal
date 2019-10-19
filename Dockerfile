FROM python:3.4
WORKDIR /usr/src/dbt
COPY build/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 80
COPY . .
CMD [ "python", "./app.py" ]
# Set proxy server, replace host:port with values for your servers
ENV http_proxy host:port
ENV https_proxy host:port
