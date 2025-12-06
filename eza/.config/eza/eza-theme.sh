#!/bin/bash

# 读取 YAML 文件
THEME_FILE="$HOME/.config/eza/theme.yml"

# 检查是否已安装 yq（YAML 解析工具）
if ! command -v yq &> /dev/null; then
  echo "请先安装 yq: https://github.com/mikefarah/yq"
  exit 1
fi

# 解析颜色配置
EZA_COLORS=$(
  yq eval '.colors | to_entries | map(
    if .key == "extensions" then
      .value | to_entries | map("*.\(.key)=\(.value)") | join(":")
    elif .key == "permissions" then
      .value | to_entries | map("ur=\(.value):uw=\(.value):ux=\(.value)") | join(":")
    else
      "\(.key)=\(.value)"
    end
  ) | join(":")' "$THEME_FILE"
)

# 设置环境变量
export EZA_COLORS

# 构建 eza 命令别名
EZA_ALIAS="eza"
if [ "$(yq eval '.icons.enable' "$THEME_FILE")" = "true" ]; then
  EZA_ALIAS="$EZA_ALIAS --icons=$(yq eval '.icons.type' "$THEME_FILE")"
fi
if [ "$(yq eval '.options.group_directories_first' "$THEME_FILE")" = "true" ]; then
  EZA_ALIAS="$EZA_ALIAS --group-directories-first"
fi

alias eza="$EZA_ALIAS"