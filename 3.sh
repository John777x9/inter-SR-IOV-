#!/bin/bash

echo "[步骤 1] 更新系统并安装必要的软件包..."
apt update -y && apt upgrade -y
apt install -y build-essential dkms wget sysfsutils pve-headers-$(uname -r)

echo "[步骤 2] 下载并安装 i915 SR-IOV DKMS..."
wget -O /tmp/i915-sriov-dkms_2025.02.03_amd64.deb "https://github.com/strongtz/i915-sriov-dkms/releases/download/2025.02.03/i915-sriov-dkms_2025.02.03_amd64.deb"
dpkg -i /tmp/i915-sriov-dkms_2025.02.03_amd64.deb

echo "[步骤 3] 检查核显设备..."
GPU_ID=$(lspci | grep VGA | awk '{print $1}')
if [ -z "$GPU_ID" ]; then
    echo "❌ 未找到核显设备，请检查 lspci 输出！"
    exit 1
fi
echo "✔️ 核显 ID: $GPU_ID"
echo "devices/pci0000:00/$GPU_ID/sriov_numvfs = 3" > /etc/sysfs.conf

echo "[步骤 4] 更新 initramfs 并准备重启..."
update-initramfs -u -k all

echo "=============================="
echo "  操作完成，请手动检查核显是否成功"
echo "  在 SHELL 窗口输入：lspci | grep VGA"
echo "  然后按 Enter 键重启系统"
echo "=============================="
read -p "按 Enter 键重启..." enter
reboot
