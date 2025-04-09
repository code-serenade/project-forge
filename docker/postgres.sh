#!/bin/bash

# 启动PostgreSQL容器的脚本
# 使用PostgreSQL最新版本
# 设置时区为亚洲/上海
# 配置数据库名称、用户名和密码
# 添加端口映射：主机5432端口映射到容器的5432端口

echo "正在启动PostgreSQL容器..."

docker run -d \
  --name postgres-dev \
  --restart=always \
  -p 5432:5432 \
  -e TZ=Asia/Shanghai \
  -e POSTGRES_DB=dev \
  -e POSTGRES_USER=dev \
  -e POSTGRES_PASSWORD=123 \
  -e PGDATA=/var/lib/postgresql/data/pgdata \
  -e POSTGRES_HOST_AUTH_METHOD=md5 \
  postgres:latest

if [ $? -eq 0 ]; then
  echo "PostgreSQL容器已成功启动!"
  echo "容器名称: postgres-dev"
  echo "数据库名称: dev"
  echo "用户名: dev"
  echo "密码: 123"
  echo "端口映射: 主机5432 -> 容器5432"
  echo "连接信息: localhost:5432 或 $(hostname -I | awk '{print $1}'):5432"
else
  echo "启动PostgreSQL容器失败，请检查Docker服务是否运行。"
fi