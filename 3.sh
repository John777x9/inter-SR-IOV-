#!/bin/bash

echo "========================"
echo "  继续配置 Intel i915 SR-IOV"
echo "========================"

# 5. 下载并安装 i915 SR-IOV DKMS 模块
echo "[步骤 6] 下载 i915 SR-IOV DKMS 模块..."
cd ~
git clone https://github.com/strongtz/i915-sriov-dkms.git
cd i915-sriov-dkms

echo "[步骤 7] 添加 DKMS 模块..."
dkms add .

echo "[步骤 8] 构建并安装模块..."
dkms build i915-sriov-dkms/$(cat VERSION)
dkms install i915-sriov-dkms/$(cat VERSION) --force

# 6. 配置 SR-IOV 虚拟功能数量
echo "[步骤 9] 获取核显设备 ID..."
GPU_ID=$(lspci | grep VGA | awk '{print $1}')

if [ -z "$GPU_ID" ]; then
    echo "未找到核显设备，请检查 lspci 结果。"
    exit 1
fi

echo "[步骤 10] 配置 SR-IOV 虚拟功能数量..."
echo "devices/pci0000:00/0000:00:$GPU_ID/sriov_numvfs = 3" | tee -a /etc/sysfs.conf

# 7. 重新启动以应用配置
echo "[步骤 11] 重新启动系统..."
sleep 5
reboot
