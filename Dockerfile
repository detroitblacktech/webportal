FROM python:3.6
WORKDIR /usr/src/dbt
RUN mkdir /certs
COPY build/requirements.txt ./
COPY build/certs/* /certs/
RUN pip install pipenv
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 80
EXPOSE 443
ENV FLASK_APP app.py
COPY . .
CMD [ "pipenv", "run", "gunicorn", "-w", "4", "-b", ":443", "--certfile", "/certs/fullchain.pem", "--keyfile", "/certs/privkey.pem", "app:app" ]
# Set proxy server, replace host:port with values for your servers
ENV http_proxy host:port
ENV https_proxy host:port
