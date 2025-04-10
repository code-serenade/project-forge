#!/bin/bash

# GitLab 配置参数
GITLAB_CONTAINER_NAME="gitlab"
GITLAB_IMAGE="gitlab/gitlab-ce:latest"
GITLAB_HTTP_PORT=8929
GITLAB_SSH_PORT=2424
# GITLAB_HTTPS_PORT=10443
GITLAB_DATA_PATH="$HOME/gitlab-data"
# GITLAB_HOSTNAME="git.example.org"  # 替换为你的域名或IP地址
GITLAB_HOSTNAME="192.168.1.31"  # 替换为你的域名或IP地址

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
  echo "❌ Docker 未安装，请先安装 Docker。"
  exit 1
fi

# 创建持久化数据目录
mkdir -p "$GITLAB_DATA_PATH/config" "$GITLAB_DATA_PATH/logs" "$GITLAB_DATA_PATH/data"

# 拉取镜像（如果尚未存在）
echo "🚀 拉取 GitLab CE 镜像（如果尚未存在）..."
docker pull $GITLAB_IMAGE

# 启动容器
echo "🚧 正在启动 GitLab 容器..."
docker run -d \
  --name $GITLAB_CONTAINER_NAME \
  --hostname $GITLAB_HOSTNAME \
  --env GITLAB_OMNIBUS_CONFIG="external_url 'http://$GITLAB_HOSTNAME:$GITLAB_HTTP_PORT'; gitlab_rails['gitlab_shell_ssh_port'] = $GITLAB_SSH_PORT" \
  --restart always \
  -p $GITLAB_HTTP_PORT:8929 \
  -p $GITLAB_SSH_PORT:22 \
  -v "$GITLAB_DATA_PATH/config":/etc/gitlab \
  -v "$GITLAB_DATA_PATH/logs":/var/log/gitlab \
  -v "$GITLAB_DATA_PATH/data":/var/opt/gitlab \
  --shm-size 256m \
  $GITLAB_IMAGE

echo "✅ GitLab 已启动！"
echo "📍 Web访问：http://$GITLAB_HOSTNAME:$GITLAB_HTTP_PORT"
docker exec -it $GITLAB_CONTAINER_NAME grep 'Password:' /etc/gitlab/initial_root_password
