<img src="https://avatars.githubusercontent.com/u/53193414?s=200&v=4" alt="logo" width="200" height="200" align="right">

# ImmortalWrt for Gemtek XR1710G（NetDoge 定制版）

[![Build Status](https://img.shields.io/github/actions/workflow/status/NetDoge/ImmortalWrt-XR1710G/build-firmware.yml?branch=master&label=Build)](https://github.com/NetDoge/ImmortalWrt-XR1710G/actions/workflows/build-firmware.yml)
[![Sync Status](https://img.shields.io/github/actions/workflow/status/NetDoge/ImmortalWrt-XR1710G/sync-upstream.yml?branch=master&label=Sync)](https://github.com/NetDoge/ImmortalWrt-XR1710G/actions/workflows/sync-upstream.yml)
[![Fork](https://img.shields.io/badge/fork-naoki66%2FImmortalWrt--for--Gemtek--XR1710G-blue)](https://github.com/naoki66/ImmortalWrt-for-Gemtek-XR1710G)
[![Kernel](https://img.shields.io/badge/kernel-6.18.x-red)](https://www.kernel.org/)
[![SoC](https://img.shields.io/badge/SoC-Airoha%20AN7581GT-orange)]()
[![License](https://img.shields.io/badge/license-GPL--2.0-green)](https://spdx.org/licenses/GPL-2.0-only.html)

基于 [naoki66/ImmortalWrt-for-Gemtek-XR1710G](https://github.com/naoki66/ImmortalWrt-for-Gemtek-XR1710G) 定制，为 Gemtek XR1710G（Brightspeed XR1710G / Airoha AN7581GT）路由器构建的 ImmortalWrt 固件。fork 自上游，按个人需求调整了默认配置与预装软件包。

**默认管理地址：http://192.168.8.1 或 http://immortalwrt.lan，用户名 root，密码 admin。**

首次启动的无线网络为 `XR1710G`（2.4G）、`XR1710G-5G`、`XR1710G-6G`，统一初始密码 `12345678`。2.4GHz 为 WPA2，5GHz 为 WPA2/WPA3 混合，6GHz 为 WPA3。首次登录后请及时修改管理密码和无线密码。

## 设备规格

| 项目 | 参数 |
|------|------|
| **SoC** | Airoha AN7581GT (1.3GHz 4核CPU + 8核NPU) |
| **内存** | 2GB |
| **闪存** | 512MB |
| **网口** | 2×10G RTL8261BE + 2×1G AN7581 |
| **PWM风扇** | 新唐 NCT7802 |
| **电源规格** | 12V 5A |

### 无线局域网 (MT7996AV BE19000)

| 频段 | 芯片 | 规格 | 最高速率 |
|------|------|------|----------|
| WLAN1 | MT7976GN | 2.4GHz 4×4 (Tx/Rx) 4096 QAM 40 MHz | 1376 Mbps |
| WLAN2 | MT7977BN | 5GHz 4×4 (Tx/Rx) 4096 QAM 160 MHz | 5.76 Gbps |
| WLAN3 | MT7977AN | 6GHz 4×5 (Tx/Rx) 4096 QAM 320 MHz (backhaul) | 10 Gbps |

## 相对上游的定制

### 默认配置

- **管理地址**改为 `192.168.8.1`（原为 `192.168.50.1`），hostname 保持 `ImmortalWrt`（`http://immortalwrt.lan` 可用）。
- 首次启动密码设为 **admin**（经 `default-settings` 首次进入时写入，带 `imm_init` 标志只执行一次，之后你改的密码不会被覆盖）。
- 无线 SSID 改为 `XR1710G` / `XR1710G-5G` / `XR1710G-6G`（加密档位沿用上游：2.4G=WPA2、5G=混合、6G=WPA3，密码 12345678）。

### 软件包调整

**移除**（减小体积、精简界面）：

| 已移除 | 原因 |
|--------|------|
| `luci-app-lucky` | 不用 Lucky |
| `luci-app-ddns-go` | 与 `luci-app-ddns` 重复 |
| `luci-app-msd_lite` | 不需要组播 |
| `luci-app-wechatpush` | 不用微信推送 |

**新增**：

| 新增 | 功能 |
|------|------|
| `luci-theme-design` + `luci-app-design-config` | design 主题（默认）及配置页，含中文包 |
| `luci-app-openclash` | OpenClash 代理（中文内置模块） |
| `luci-app-smartdns`（含 WebUI） | SmartDNS 本地 DNS/分流 |
| `luci-app-airoha-factory` | Airoha XR1710G Factory 分区编辑 |

### 预装 LuCI 应用

#### 设备专属与仓库内置（来自 [`package/`](package/)）

| 应用 | 来源 | 功能 |
|------|------|------|
| `luci-app-airoha-npu` | [rchen14b/luci-app-airoha-npu](https://github.com/rchen14b/luci-app-airoha-npu) | SoC/NPU 状态、加速开关与超频控制 |
| `luci-app-airoha-fancontrol` | [Gilly1970/Gemtek-W1700K](https://github.com/Gilly1970/Gemtek-W1700K) | 风扇速度/温度控制与曲线 |
| `luci-app-airoha-flowsense` | [Gilly1970/Gemtek-W1700K](https://github.com/Gilly1970/Gemtek-W1700K) | PPE 硬件 offload、VLAN 标签/PPPoE 透传/AP 模式卸载状态与延迟检测 |
| `luci-app-airoha-factory` | 本仓库 | Airoha XR1710G Factory 分区编辑 |
| `luci-app-airoha-recovery` | 本仓库 | 一键重启进入 U-Boot HTTP Recovery（一次性触发） |

#### 网络与远程接入

| 应用 | 功能 |
|------|------|
| `luci-app-zerotier` | ZeroTier 虚拟局域网 |
| `luci-app-ddns` | 传统 DDNS 脚本 |
| `luci-app-upnp` | UPnP 自动端口转发 |
| `luci-app-firewall` | 防火墙（firewall4/nftables） |
| `luci-app-arpbind` | IP/MAC 绑定 |
| `luci-app-mlo` | MLO（Wi-Fi 7 多链路操作） |
| `luci-app-openclash` | OpenClash 代理客户端 |
| `luci-app-smartdns` | SmartDNS 本地 DNS/分流 |
| `luci-app-vlmcsd` | KMS 激活服务（含 vlmcsd 服务端） |

#### 系统与自动化

| 应用 | 功能 |
|------|------|
| `luci-app-package-manager` | APK 包管理器 |
| `luci-app-ttyd` | Web 终端 |
| `luci-app-autoreboot` | 定时重启 |
| `luci-app-timewol` | 定时网络唤醒 |
| `luci-app-wifischedule` | Wi-Fi 定时开关 |
| `luci-app-watchcat` | 网络看门狗 |
| `luci-app-wol` | 网络唤醒 |
| `luci-app-rtp2httpd` | RTP 转 HTTP |
| `luci-app-udpxy` | UDP 组播代理 |
| `luci-app-wifihistory` | WiFi 历史记录 |

### 主要系统包

**网络核心**
- `dnsmasq-full`（完整版 DNS/DHCP）
- `firewall4` + `nftables-json`（nftables 防火墙）
- `wpad-mbedtls`（WPA2/WPA3、EHT/MLO 支持）
- `odhcp6c` / `odhcpd-ipv6only`（IPv6）
- `ppp` / `ppp-mod-pppoe`（PPPoE）
- `smartdns`（DNS 加速/分流）
- `wireguard-tools` + `luci-proto-wireguard` + `rpcd-mod-wireguard`（WireGuard）

**内核模块（kmod）**
- `kmod-mt7996-firmware` / `kmod-mt7996e`（MT7996 Wi-Fi 7 驱动）
- `airoha-en7581-mt7996-npu-firmware`（Airoha NPU 固件）
- `kmod-crypto-hw-eip93`（硬件加密加速）
- `kmod-nft-offload`（硬件流量卸载）
- `kmod-br-netfilter` / `kmod-tcp-bbr`（桥接 Netfilter / BBR 拥塞控制）
- `kmod-wireguard`（WireGuard 内核支持）
- `kmod-hwmon-nct7802`（NCT7802 温度传感器）
- `kmod-i2c-an7581` / `kmod-leds-gpio` / `kmod-gpio-button-hotplug`
- `kmod-phy-realtek` / `kmod-mt76-connac` / `kmod-mt76-core`
- `rtl826x-firmware`（RTL8261BE PHY 固件）

**系统工具**
- `bash` / `coreutils` / `curl` / `ip-full`
- `ethtool-full` / `pciutils` / `uboot-envtools`
- `luci-theme-design`（默认）+ `luci-theme-bootstrap`
- `default-settings-chn`（中文默认设置）

## 网络与无线默认行为

- 默认 LAN 地址为 `192.168.8.1`；IPv6 使用 SLAAC/EUI-64，关闭 DHCPv6/NDP 与 RA DNS/附加标志，减少国内网络环境下的兼容性问题。
- 默认开启 firewall4 软件 flow offload 与硬件 flow offload；VLAN 标签卸载、PPPoE 透传卸载和 AP 模式加速可在 NPU 页面按需启用，并由 FlowSense 展示运行状态。
- 三个无线射频默认启用：2.4GHz 为 HE20/自动信道，5GHz 为 EHT160/信道 36，6GHz 为 EHT320/信道 37。
- FlowSense 提供 Router/AP 模式、VLAN 标签/PPPoE 透传/AP 模式卸载状态与自定义 Ping 延迟检测；NPU 页面提供 PPE/Frame Engine、CPU 频率与安全超频控制；风扇页面提供实时温度、RPM/PWM 曲线与自定义曲线。

## 设备树与内核补丁

- 独立 XR1710G 设备树 [an7581-xr1710g-ubi.dts](target/linux/airoha/dts/an7581-xr1710g-ubi.dts)（基于公共 `an7581.dtsi` 与 `an7581-npu-mt7996.dtsi` 扩展，含 PCIe 3.0 x2 模式配置）。
- 关键内核与网络补丁见 [target/linux/airoha/patches-6.18/](target/linux/airoha/patches-6.18/) 与 [target/linux/generic/pending-6.18/](target/linux/generic/pending-6.18/)（nft_flow_offload 桥接/PPE、USB/PCIe 时钟与复位、NPU 修复、PPE/flowtable 硬件卸载、WLAN 流绑定、VLAN ingress/XFRM 流支持等）。
- 无线栈补丁：`package/kernel/mt76/patches/` 中 `001`（mt7996 PS sync TLV/MLO 稳定性）与 `9993`（operating-mode rate control）；mac80211 与 hostapd 补丁（6GHz、EHT、radio mask 及多 VAP 稳定性）。
- 启动与设备定制：`03_wifi_defaults`（SSID、加密方式、US 区域码）、`03_wireless`（射频参数）、`18-xr1710g-firewall-defaults`（默认软件/硬件 flow offload）、`99-ppe-reload`（无线接口创建后重载防火墙）、`packet-steering.sh`（Wi-Fi worker/CPU 亲和性）、风扇服务、升级平台脚本。

## GitHub Actions 工作流

| 工作流 | 触发方式 | 功能 |
|--------|---------|------|
| [build-firmware.yml](.github/workflows/build-firmware.yml) | 手动 (workflow_dispatch) | 构建固件并发布 Release |
| [sync-upstream.yml](.github/workflows/sync-upstream.yml) | 每 3 天定时（UTC 19:00≈北京凌晨 3 点）+ 手动 | 同步 ImmortalWrt 上游 |

**构建配置**：仓库根目录的 [config.seed](config.seed) 是完整配置文件（含全部包与默认配置开关），Action 自动执行 `cp config.seed .config && bash scripts/set-build-version.sh .config && make defconfig`。

**手动触发**：Actions → Build XR1710G Custom Firmware → Run workflow，选择 Release 类型（`none` / `release` / `prerelease`）。

**Release 名称**：`YYYYMMDD - XR1710G Build (<short-hash>)`，Tag 为 `YYYYMMDD-<short-hash>`。

## 下载

- [Releases 页面](https://github.com/NetDoge/ImmortalWrt-XR1710G/releases)
- 固件文件：`immortalwrt-netdoge-xr1710g-YYYYMMDD-<hash>-airoha-an7581-gemtek_xr1710g-ubi-squashfs-sysupgrade.itb`
- 升级方法：LuCI → 系统 → 备份/升级 → 刷写固件

### 升级注意事项

> [!WARNING]
> LuCI 中的"保留配置"不会保留额外安装的软件包。升级前请备份配置并记录已安装的软件包；升级后需要
> 重新安装 OpenClash 等非预装组件。请使用与新固件匹配的软件包，不要恢复旧固件的 `kmod-*` 内核模块。

## 本地构建（可选）

```bash
git clone https://github.com/NetDoge/ImmortalWrt-XR1710G.git
cd ImmortalWrt-XR1710G
./scripts/feeds update -a
./scripts/feeds install -a
bash scripts/fix-stale-golang-host.sh
cp config.seed .config
bash scripts/set-build-version.sh .config
make defconfig
make -j$(nproc) world 2>&1 | tee build.log
bash scripts/summarize-build-errors.sh build.log
```

构建环境要求：GNU/Linux 系统（Debian 11+ 推荐），AMD64 架构（云编译 runner 4 核），至少 4GB RAM 和 25GB 可用磁盘空间。详细依赖请参考 [ImmortalWrt 官方文档](https://openwrt.org/docs/guide-developer/build-system/install-buildsystem)。

## 致谢

### 上游
- [naoki66/ImmortalWrt-for-Gemtek-XR1710G](https://github.com/naoki66/ImmortalWrt-for-Gemtek-XR1710G) - 本仓库的 fork 基础
- [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt) - ImmortalWrt 主项目
- [immortalwrt/luci](https://github.com/immortalwrt/luci) - LuCI Web 界面
- [immortalwrt/packages](https://github.com/immortalwrt/packages) - 社区软件包仓库
- [openwrt/routing](https://github.com/openwrt/routing) - OpenWrt 路由相关包
- [openwrt/mt76](https://github.com/openwrt/mt76) - MediaTek WiFi 驱动

### 参考项目
- [YYH2913/openwrt](https://github.com/YYH2913/openwrt) - XR1710G 6.18 内核集成参考
- [hurrian/openwrt-w1700k](https://github.com/hurrian/openwrt-w1700k) - XR1710G PCIe 3.0 x2 补丁参考
- [lvcdy/openwrt_xr1710g](https://github.com/lvcdy/openwrt_xr1710g) - XR1710G 早期移植参考

### LuCI 应用来源
- [rchen14b/luci-app-airoha-npu](https://github.com/rchen14b/luci-app-airoha-npu) - Airoha NPU 状态监控
- [Gilly1970/Gemtek-W1700K](https://github.com/Gilly1970/Gemtek-W1700K) - Airoha 风扇控制与 FlowSense
- [gngpp/luci-app-design-config](https://github.com/gngpp/luci-app-design-config) - design 主题配置

## 许可证

[GPL-2.0-only](https://spdx.org/licenses/GPL-2.0-only.html)（继承 ImmortalWrt）