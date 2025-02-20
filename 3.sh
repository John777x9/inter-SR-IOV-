#!/bin/bash

echo "========================"
echo "  配置 Intel i915 SR-IOV"
echo "========================"

# 1. 更新系统并安装必要的软件包
echo "[步骤 1] 安装必要的软件包..."
apt update -y && apt upgrade -y
apt install -y build-* dkms git sysfsutils
apt install -y proxmox-headers-$(uname -r) proxmox-kernel-$(uname -r)

# 2. 下载并安装 i915 SR-IOV DKMS 模块
echo "[步骤 2] 下载并安装 i915 SR-IOV DKMS 模块..."
cd ~
git clone https://github.com/strongtz/i915-sriov-dkms.git
cd ~/i915-sriov-dkms
dkms add .
dkms install -m i915-sriov-dkms -v $(cat VERSION) --force

# 3. 获取核显 ID
echo "[步骤 3] 获取核显 ID..."
GPU_ID=$(lspci -nn | grep VGA | awk '{print $1}')
if [[ -z "$GPU_ID" ]]; then
    echo "❌ 未找到核显，请检查系统是否支持 SR-IOV。"
    exit 1
fi
echo "✔️  检测到核显 ID: $GPU_ID"

# 4. 配置 SR-IOV
echo "[步骤 4] 配置 SR-IOV..."
echo "devices/pci0000:00/${GPU_ID}/sriov_numvfs = 3" > /etc/sysfs.conf
echo "✔️  配置已写入 /etc/sysfs.conf"

# 5. 提示用户检查直通状态，并等待回车
echo "======================================"
echo "  请在 SHELL 窗口手动输入以下命令："
echo "  lspci | grep VGA"
echo "  重启后检查是否成功直通！"
echo "  按下 [Enter] 键后系统将重启..."
echo "======================================"
read -r  # 等待用户按下回车

# 6. 进行重启
echo "系统即将重启，请稍候..."
sleep 3
reboot
