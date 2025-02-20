#!/bin/bash

echo "=============================="
echo "  绕过 Proxmox 订阅检测"
echo "=============================="

# 1. 备份原始文件
echo "[步骤 1] 备份原始文件..."
cp /usr/share/pve-manager/js/pvemanagerlib.js /usr/share/pve-manager/js/pvemanagerlib.js.bak
cp /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js.bak

# 2. 修改 JavaScript 文件，去除订阅检查
echo "[步骤 2] 修改订阅检查代码..."
sed -i "s/data.status === 'Active'/true/g" /usr/share/pve-manager/js/pvemanagerlib.js
sed -i "s/if (res === null || res === undefined || \!res || res/if(/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
sed -i "s/.data.status.toLowerCase() !== 'active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js

# 3. 重启 pveproxy 服务，使更改生效
echo "[步骤 3] 重启 pveproxy 服务..."
systemctl restart pveproxy

echo "=============================="
echo "  订阅检测已绕过，操作完成！"
echo "=============================="

# 4. 等待用户按回车键后退出
read -p "按回车键结束脚本..." 
