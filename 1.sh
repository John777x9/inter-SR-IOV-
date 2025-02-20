#!/bin/bash

echo "========================"
echo "  配置 Intel i915 SR-IOV"
echo "========================"

# 1. 更新系统并安装必要的软件包
echo "[步骤 1] 更新系统..."
apt update -y && apt upgrade -y

echo "[步骤 2] 安装必要的软件包..."
apt install -y build-essential dkms git sysfsutils pve-headers-$(uname -r)

# 2. 修改 GRUB 配置，启用 IOMMU 和 i915 SR-IOV
echo "[步骤 3] 配置 GRUB..."
sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT/c\GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt pcie_acs_override=downstream i915.enable_guc=3 i915.max_vfs=3"' /etc/default/grub

# 3. 确保 VFIO 模块加载
echo "[步骤 4] 配置 VFIO 模块..."
echo -e "vfio\nvfio_iommu_type1\nvfio_pci\nvfio_virqfd" | tee -a /etc/modules

# 4. 更新 GRUB 配置和 initramfs
echo "[步骤 5] 更新 GRUB 并重启..."
update-grub
update-initramfs -u -k all
echo "系统即将重启，请等待..."
sleep 5
reboot

# 5. 重启后检查 SR-IOV 状态（重启后才会执行）
echo "[步骤 6] 检查核显直通是否成功..."
lspci -nn | grep VGA
cat /sys/class/drm/card0/device/sriov_numvfs
