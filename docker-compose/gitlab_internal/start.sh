#!/bin/bash

# 设置 env 文件路径
ENV_FILE=".env"
ENV_EXAMPLE="env-example"

# 如果 .env 不存在，复制 env-example
if [ ! -f "$ENV_FILE" ]; then
  echo "📝 未找到 .env，正在复制 $ENV_EXAMPLE..."
  cp "$ENV_EXAMPLE" "$ENV_FILE"
else
  echo "✅ 已存在 .env，跳过复制"
fi

# 启动 docker compose 服务
echo "🚀 正在启动服务..."
docker compose up -d
