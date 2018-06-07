# install-scripts安装脚本
# 1、安装Kubernetes集群
## 1.1、每台机器上安装git，并获取安装脚本
```
yum install git -y
git clone https://github.com/IvoryRaptor/install-scripts
```
## 1.2、安装 master
```
cd install-scripts/k8s
sh kubeadm.sh 39.106.153.134 master 863f67.19babbff7bfe8543#安装集群Master
```
>> 注意：此处后面的位token，集群中该值必须统一。

## 1.3、在集群中其他机器上，安装 slave
```
cd install-scripts/k8s
sh kubeadm.sh 39.106.153.134 slave 863f67.19babbff7bfe8543#其他机器安装
```
>> 注意：此处后面的位token，集群中该值必须统一。

## 1.4、检查集群安装情况，在master上运行
```
kubectl get nodes
```

## 1.5、根据实际情况为各Node打上标签
```
kubectl label nodes node_name key=value
```

名称 | 描述
---- | ---
kafka | 发出消息的设备
mongodb | 接收消息的设备
redis | 资源名称
zookeeper | 操作名称
payload | 附加数据


# 2、搭建私有镜像仓库
## 2.1 搭建私有镜像仓库

# 3、安装基础组件
## 3.1、安装Zookeeper、Kafka

### 3.1.1、首先给运行zookeeper和kafka的node打标签
```
kubectl label nodes iz2zeca3p5tq7g7kefj8o0z zookeeper=true
kubectl label nodes iz2zeca3p5tq7g7kefj8o0z kafka=true
```

### 3.1.2、在运行目标机器上创建存储
```
mkdir -p /mnt/data/kafka
mkdir -p /mnt/data/zookeeper
```

### 3.1.3、安装zookeeper和kafka
```
cd install-scripts/software/
sh kafka.sh 39.106.153.134
```

## 3.2、安装Redis

## 3.3、安装Mongodb

# 4、安装监控组件

## 4.1、安装Elasticsearch

## 4.2、安装Kibana

## 4.3、安装Influxdb

## 4.4、安装Grafana

## 4.5、安装Hadoop

## 4.6、安装Spark

## 4.7、安装Kubernetes Dashboard

# 5、安装服务各组件

## 5.1、安装PostOffice组件

## 5.2、安装Dashboard
