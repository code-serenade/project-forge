#!/bin/bash

# 设置变量
CONTAINER_NAME="registry"
REGISTRY_PORT="5000"
DATA_DIR="$HOME/registry/data"
IMAGE_NAME="registry:latest"

# 创建数据目录（如果不存在）
mkdir -p $DATA_DIR

# 检查是否已有同名容器在运行
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "⚠️ 容器 '${CONTAINER_NAME}' 已存在，正在删除旧容器..."
  docker rm -f $CONTAINER_NAME
fi

# 运行 Registry 容器
echo "🚀 启动 Docker Registry 容器..."
docker run -d \
  --name $CONTAINER_NAME \
  --restart always \
  -p ${REGISTRY_PORT}:5000 \
  -v ${DATA_DIR}:/var/lib/registry \
  $IMAGE_NAME

# 显示运行状态
echo "✅ Registry 已部署，监听端口: ${REGISTRY_PORT}"
docker ps --filter "name=$CONTAINER_NAME"
