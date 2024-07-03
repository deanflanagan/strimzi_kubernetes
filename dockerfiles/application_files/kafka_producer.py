from confluent_kafka.admin import AdminClient, NewTopic
import os 
import base64

SYSTEMS_KAFKA_CLUSTER_KAFKA_BOOTSTRAP_PORT_9092_TCP_PORT = os.environ.get('SYSTEMS_KAFKA_CLUSTER_KAFKA_BOOTSTRAP_PORT_9092_TCP_PORT')
SYSTEMS_KAFKA_CLUSTER_KAFKA_BOOTSTRAP_PORT_9092_TCP_ADDR = os.environ.get('SYSTEMS_KAFKA_CLUSTER_KAFKA_BOOTSTRAP_PORT_9092_TCP_ADDR')

conf = {
    'bootstrap.servers': f'{SYSTEMS_KAFKA_CLUSTER_KAFKA_BOOTSTRAP_PORT_9092_TCP_ADDR}:{SYSTEMS_KAFKA_CLUSTER_KAFKA_BOOTSTRAP_PORT_9092_TCP_PORT}',
    'sasl.mechanism': 'SCRAM-SHA-512',
    'security.protocol': 'SASL_PLAINTEXT',
    'sasl.username': 'SYSTEMS_KAFKA_USER',
    'sasl.password': base64.b64decode('cWtzVG1KUnJoa0NESUVLaDBybHN3ZjVsYmpSbzlYNnM=').decode()
}

kadmin = AdminClient(conf)

new_topic = NewTopic("topic_one", num_partitions=2, replication_factor=3)

fs = kadmin.create_topics([new_topic])

for topic, f in fs.items():
    try:
        f.result()  # The result itself is None
        print("Topic {} created".format(topic))
    except Exception as e:
        print("Failed to create topic {}: {}".format(topic, e))

print('Topics from python:')
print(kadmin.list_topics().topics)