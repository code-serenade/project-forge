#!/bin/bash

# Runner 容器名称
RUNNER_NAME="gitlab-runner"

# 配置路径（主机保存配置）
CONFIG_DIR="$HOME/gitlab-runner/config"

# 镜像名
IMAGE_NAME="gitlab/gitlab-runner:latest"

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
  echo "❌ Docker 未安装，请先安装 Docker。"
  exit 1
fi

# 创建配置目录
mkdir -p "$CONFIG_DIR"

# 如果已有容器，先删除
if docker ps -a --format '{{.Names}}' | grep -q "^${RUNNER_NAME}$"; then
  echo "⚠️ 检测到已有 Runner 容器，正在删除..."
  docker stop $RUNNER_NAME && docker rm $RUNNER_NAME
fi

# 启动 GitLab Runner 容器
echo "🚀 启动 GitLab Runner 容器..."
docker run -d --name $RUNNER_NAME --restart always \
  -v "$CONFIG_DIR":/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  $IMAGE_NAME

echo "✅ Runner 容器已启动，下一步请执行以下命令进行注册："
echo
echo "👉 docker exec -it $RUNNER_NAME gitlab-runner register"
echo
echo "你可以访问你的 GitLab 实例，复制项目的 Runner 注册 Token，进行注册绑定。"
