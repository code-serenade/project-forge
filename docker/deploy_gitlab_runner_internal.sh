#!/bin/bash

# Runner 容器名称
RUNNER_NAME="gitlab-runner"

# 配置路径（主机保存配置）
CONFIG_DIR="$HOME/gitlab-runner/config"

# 镜像名
IMAGE_NAME="gitlab/gitlab-runner:latest"

# GitLab 实例地址（修改为你的 GitLab 实际地址）
GITLAB_URL="http://192.168.1.31:8929"

# Runner Authentication Token（glrt-xxxx）
AUTH_TOKEN="glrt-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# Runner 描述与标签（可根据需要修改）
DESCRIPTION="my-runner"
TAGS="docker,ci"
EXECUTOR="docker"
DEFAULT_IMAGE="alpine:latest"

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
  echo "❌ Docker 未安装，请先安装 Docker。"
  exit 1
fi

# 创建配置目录
mkdir -p "$CONFIG_DIR"

# 删除已有容器
if docker ps -a --format '{{.Names}}' | grep -q "^${RUNNER_NAME}$"; then
  echo "⚠️ 检测到已有 Runner 容器，正在删除..."
  docker stop $RUNNER_NAME && docker rm $RUNNER_NAME
fi

# 启动 Runner 容器
echo "🚀 启动 GitLab Runner 容器..."
docker run -d --name $RUNNER_NAME --restart always \
  -v "$CONFIG_DIR":/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  $IMAGE_NAME

# 执行注册（使用 authentication token）
echo "🔐 使用 authentication token 注册 Runner..."
docker exec -it $RUNNER_NAME gitlab-runner register \
  --non-interactive \
  --url "$GITLAB_URL" \
  --token "$AUTH_TOKEN" \
  --executor "$EXECUTOR" \
  --description "$DESCRIPTION" \
  --tag-list "$TAGS" \
  --docker-image "$DEFAULT_IMAGE"

echo
echo "✅ Runner 注册完成！你可以在 GitLab 管理后台查看该 Runner 状态。"
