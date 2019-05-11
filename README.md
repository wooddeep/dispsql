# 1. 简述dispsql
基于citusdata:v8.1制作的docker镜像，可用于搭建跨物理节点的分布式postgres数据库(因为官方的docker镜像只能在一个物理节点上启动分布式postgres)。

# 2. 生成镜像
docker build . -t dispsql:v0.0.1

# 2. 运行分布式postgres
##  3.1 运行主控节点coordinator(所在ip:192.168.140.95)
docker run -d -p 9700:9700 dispsql:v0.0.1

## 3.2 运行workder（所在ip:192.168.140.94）
docker run -d -p 9701:9700 dispsql:v0.0.1

## 3.3 往coordinator中添加worker
docker exec -it <coordinator_container_id> psql -p 9700 -c "select master_add_node(<worker_ip>, 9701);"

docker exec -it 85a3007ccda7 psql -p 9700 -c "select master_add_node('192.168.140.94', 9701);"  ## 地址为docker网桥的地址

## 3.4 数据库操作
### 查询工作节点
docker exec -it <coordinator_container_id> psql -p 9700 -c "select * from master_get_active_worker_nodes();"

docker exec -it 85a3007ccda7 psql -p 9700 -c "select * from master_get_active_worker_nodes();"

### 连接主控节点
psql -p 9700 -h 192.168.140.95 -U postgres -d postgres

### 建表
CREATE TABLE test (
    id bigint NOT NULL,
    name text NOT NULL
);

ALTER TABLE test ADD PRIMARY KEY (id);

### 表分片
SELECT create_distributed_table('test', 'id');

### 插入数据
insert into test(id, name) values (1, 'lihan');

### 连接工作接地
psql -p 9700 -h 192.168.140.94 -U postgres -d postgres #可以查询分片的数据
