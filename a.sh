#!/bin/bash

# 设置目录和文件路径
dir="/etc/apt/sources.list.d/"
file="/etc/apt/sources.list"

# 删除 sources.list.d 目录中的内容（如果存在）
if [ -d "$dir" ]; then
  echo "Deleting directory $dir..."
  rm -rf "$dir"
  echo "Directory deleted."
else
  echo "Directory $dir does not exist. Skipping deletion."
fi

# 替换 /etc/apt/sources.list 文件中的内容为国外的源
echo "Replacing content of $file..."

echo "deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware" > "$file"
echo "deb http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware" >> "$file"
echo "deb http://deb.debian.org/debian/ bookworm-backports main contrib non-free non-free-firmware" >> "$file"
echo "deb http://security.debian.org/debian-security bookworm-security main" >> "$file"
echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" >> "$file"

echo "Content replaced."

# 更新 apt 并获取新的源
echo "[步骤] 更新 apt 源..."
apt update -y

# 完成
echo "Source update completed."
