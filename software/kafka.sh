#!/bin/bash
#sh kafka.sh 172.16.120.151

MASTER_ADDRESS=${1}

echo '============================================================'
echo '===================Create Kafka Yaml File==================='
echo '============================================================'

rm -rf kafka/20-kafka.yaml
cat >> kafka/20-kafka.yaml <<EOF
apiVersion: apps/v1beta2
kind: StatefulSet
metadata:
  name: kafka
spec:
  selector:
    matchLabels:
      app: kafka
  serviceName: "kafka"
  replicas: 1
  template:
      metadata:
        labels:
          app: kafka
      spec:
        nodeSelector:
          kafka: "true"
        terminationGracePeriodSeconds: 10
        volumes:
          - name: kafka
            hostPath:
              path: "/mnt/data/kafka"
        containers:
        - name: kafka
          image: wurstmeister/kafka:0.11.0.1
          env:
            - name: JAVA_OPTIONS
              value: "-Xmx1500m"
            - name: KAFKA_PORT
              value: "9092"
            - name: KAFKA_AUTO_CREATE_TOPICS_ENABLE
              value: "true"
            - name: KAFKA_NUM_PARTITIONS
              value: "10"
            - name: KAFKA_ADVERTISED_PORT
              value: "30092"
            - name: KAFKA_ADVERTISED_HOST_NAME
              value: "$MASTER_ADDRESS"
            - name: KAFKA_ZOOKEEPER_CONNECT
              value: zookeeper:2181
          resources:
            # need more cpu upon initialization, therefore burstable class
            limits:
              cpu: 500m
              memory: "2048Mi"
            requests:
              memory: "1024Mi"
              cpu: 100m
          ports:
            - containerPort: 9092
          volumeMounts:
            - name: kafka
              mountPath: "/kafka/"
---
apiVersion: v1
kind: Service
metadata:
  name: kafka
spec:
  type: NodePort
  ports:
    - name: kafka
      port: 9092
      nodePort: 30092
  selector:
    app: kafka
EOF
echo 'create file kafka/20-kafka.yam'

echo '============================================================'
echo '===================Create Zookeeper Kafka==================='
echo '============================================================'
kubectl create -f kafka/
