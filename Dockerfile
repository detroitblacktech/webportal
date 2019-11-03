FROM python:3.4
WORKDIR /usr/src/dbt
EXPOSE 80
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
CMD [ "python", "./app.py" ]
# Set proxy server, replace host:port with values for your servers
ENV http_proxy host:port
ENV https_proxy host:port
