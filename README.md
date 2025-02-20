Proxmox i915 SR-IOV 配置脚本

本项目包含两个 Bash 脚本，用于在 Proxmox VE 上配置 Intel i915 SR-IOV，实现核显直通和虚拟化支持。

文件说明

	•	setup_i915_sriov.sh
	•	作用：
	•	禁用 Proxmox 企业仓库，启用社区仓库
	•	更新系统并安装必要依赖
	•	克隆 i915 SR-IOV 驱动并执行安装脚本
	•	可选：配置 sysfs.conf 以启用 SR-IOV
	•	最后自动重启系统
	•	配置 Intel i915 SR-IOV.sh
	•	作用：
	•	安装 i915 SR-IOV DKMS 模块
	•	允许核显进行 SR-IOV 虚拟化

使用方法

1. 下载脚本

使用 git clone 克隆本项目：

```sh
git clone https://github.com/your-repo/proxmox-i915-sriov.git
cd proxmox-i915-sriov
```
2. 赋予脚本执行权限
```sh
chmod +x 1.sh 2.sh 3.sh
```
方法 3：使用 sh 执行
```sh
./1.sh
```
完成重启在执行第二脚本
```sh
./2.sh
```
```sh
./3.sh
```
