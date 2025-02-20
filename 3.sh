#!/bin/bash

echo "========================"
echo "  配置 Intel i915 SR-IOV"
echo "========================"

# 1. 更新系统并安装必要的软件包
echo "[步骤 1] 更新系统..."
apt update -y && apt upgrade -y

echo "[步骤 2] 安装必要的软件包..."
apt install -y build-essential dkms git sysfsutils proxmox-headers-$(uname -r) proxmox-kernel-$(uname -r)

# 2. 下载并安装 i915 SR-IOV DKMS
echo "[步骤 3] 下载并安装 i915 SR-IOV..."
cd ~
git clone https://github.com/strongtz/i915-sriov-dkms.git
cd ~/i915-sriov-dkms
dkms add .
dkms install -m i915-sriov-dkms -v $(cat VERSION) --force

# 3. 检查当前核显 ID
echo "[步骤 4] 记录当前核显 ID..."
GPU_ID=$(lspci | grep VGA | awk '{print $1}')
echo "检测到的核显 ID：$GPU_ID"

# 4. 生成 sysfs 配置
echo "[步骤 5] 生成 SR-IOV 配置..."
echo "devices/pci0000:00/${GPU_ID}/sriov_numvfs = 3" > /etc/sysfs.conf

# 5. 更新 initramfs
echo "[步骤 6] 更新 initramfs..."
update-initramfs -u -k all

# 6. 提示用户重启后检查直通情况
echo ""
echo "=============================="
echo "  直通配置已完成，即将重启..."
echo "  请在重启后运行以下命令检查直通情况："
echo "  lspci -nn | grep VGA"
echo "  cat /sys/class/drm/card0/device/sriov_numvfs"
echo "=============================="
echo ""

# 7. 倒计时 6 秒后重启
for i in {6..1}; do
    echo "重启倒计时: $i 秒..."
    sleep 1
done

reboot
