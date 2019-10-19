"""
Multi-threaded extension for streaming module
"""

import os, sys, threading, logging, time, json
import multiprocessing
from kafka import KafkaConsumer, KafkaProducer
from kafka.errors import KafkaError
from kafka.producer import future
from modules.streaming import send_stream

def print_debug(e):
    print(str(e))
    exc_type, exc_obj, exc_tb = sys.exc_info()
    fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
    print(exc_type, fname, exc_tb.tb_lineno)


class Producer(threading.Thread):
    def __init__(self, data, dt):
        threading.Thread.__init__(self)
        self.stop_event = threading.Event()
        self.data = data
        self.dt = dt

    def stop(self):
        self.stop_event.set()

    def run(self):
        send_stream(self.data, self.dt)

class Consumer(multiprocessing.Process):
    def __init__(self):
        multiprocessing.Process.__init__(self)
        self.stop_event = multiprocessing.Event()

    def stop(self):
        self.stop_event.set()

    def run(self):
        consumer = KafkaConsumer(bootstrap_servers='queuetest.flyball.co',
                                 auto_offset_reset='earliest',
                                 consumer_timeout_ms=1000,
                                 value_deserializer=lambda m: json.loads(m.decode('utf-8')))
        consumer.subscribe(['leads'])

        while not self.stop_event.is_set():
            for message in consumer:
                print(message)
                if self.stop_event.is_set():
                    break

        consumer.close()


def main():
    data = sys.argv[1]
    dt = sys.argv[2]

    tasks = [
        Producer(data=data,dt=dt),
        Consumer()
    ]

    for t in tasks:
        t.start()

    time.sleep(10)

    for task in tasks:
        task.stop()

    for task in tasks:
        task.join()


if __name__ == "__main__":
    logging.basicConfig(
        format='%(asctime)s.%(msecs)s:%(name)s:%(thread)d:%(levelname)s:%(process)d:%(message)s',
        level=logging.INFO
    )
    main()
