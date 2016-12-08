""" worker """
import sys
import time
import redis

redis_host = 'stg-redis.pj9pbo.ng.0001.use1.cache.amazonaws.com'
redis_queue_name = 'queue'

r = redis.StrictRedis(host=redis_host)


def get_message_from_redis():
    data = r.rpop(redis_queue_name)
    if data is not None:
        data = data.decode('utf-8')
    return data


def process():
    while True:
        data = get_message_from_redis()
        if data is not None:
            print('Got message: ' + data)
        else:
            print('No messages')
        time.sleep(5)

if __name__ == "__main__":
    print('starting worker..')
    process()
