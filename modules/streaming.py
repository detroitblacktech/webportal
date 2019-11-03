import os, sys, json

from flask import jsonify
from kafka import KafkaProducer, future
from kafka.errors import KafkaError

# for Debugging
def print_debug(e):
    print(str(e))
    exc_type, exc_obj, exc_tb = sys.exc_info()
    fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
    print(exc_type, fname, exc_tb.tb_lineno)

def send_stream(data, dt):
    # remove any hyphens from phone number
    data['phone'] = data['phone'].replace('-', '')

    # broker configs
    broker_url = "queuetest.flyball.co"
    broker_port = "9092"
    bootstrap_server="{}:{}".format(broker_url, broker_port)

    producer = KafkaProducer(bootstrap_servers=[bootstrap_server], value_serializer=lambda m: json.dumps(m).encode('utf-8'), retries=3)
    print("Kafka Producer opened")
    # producer = KafkaProducer(bootstrap_servers=[bootstrap_server], retries=3)

    payload = {
        'type': 'email',
        'brand': 'detroitpbx',
        'datetime': dt.strftime('%Y-%m-%d %H:%M:%S'),
        'name': data['name'],
        'phone': data['phone'],
        'email': data['email'],
        'message': data['message']
    }

    print("Sending stream")
    future = producer.send(
        'leads', payload
    )
    # producer.send('leads', '{type: email,brand: detroitpbx,datetime: dt,name: data[name],phone: data[phone],email: data[email],message: data[message]}')
    print("Stream sent")
    producer.close()
    print("Kafka Producer closed")


    # Block for 'synchronous' sends
    try:
        record_metadata = future.get(timeout=15)
        # Successful result returns assigned partition and offset
        print("Topic: {}".format(record_metadata.topic))
        print("Partition: {}".format(record_metadata.partition))
        print("Offset: {}".format(record_metadata.offset))
    except Exception as e:
        print_debug(e)
        raise
