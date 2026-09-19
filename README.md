<img src="https://avatars.githubusercontent.com/u/53193414?s=200&v=4" alt="logo" width="120" height="120" align="right">

# ImmortalWrt for XR1710G（NetDoge 定制版）

[![Build Status](https://img.shields.io/github/actions/workflow/status/NetDoge/ImmortalWrt-XR1710G/build-firmware.yml?branch=master&label=Build)](https://github.com/NetDoge/ImmortalWrt-XR1710G/actions/workflows/build-firmware.yml)
[![Sync Status](https://img.shields.io/github/actions/workflow/status/NetDoge/ImmortalWrt-XR1710G/sync-upstream.yml?branch=master&label=Sync)](https://github.com/NetDoge/ImmortalWrt-XR1710G/actions/workflows/sync-upstream.yml)

给 Gemtek XR1710G（Airoha AN7581GT）用的 ImmortalWrt 固件，fork 自 [naoki66/ImmortalWrt-for-Gemtek-XR1710G](https://github.com/naoki66/ImmortalWrt-for-Gemtek-XR1710G)，按个人习惯调了默认配置和预装包。

**管理地址：http://192.168.8.1（或 http://immortalwrt.lan）　用户名 root　密码 admin**
**Wi-Fi：`XR1710G`(2.4G) / `XR1710G-5G` / `XR1710G-6G`，密码统一 `12345678`**

> 首次登录后记得改管理密码和 Wi-Fi 密码。

## 我改了什么

- **管理地址**：`192.168.50.1` → `192.168.8.1`
- **默认密码**：admin（首次启动写入，只执行一次，之后你改的不覆盖）
- **Wi-Fi**：SSID 改成 `XR1710G*`，加密档位沿用上游（2.4G=WPA2 / 5G=WPA2+WPA3 / 6G=WPA3）
- **预装**：OpenClash、SmartDNS、ZeroTier、DDNS、UPnP、vlmcsd、ttyd、autoreboot、timewol、wifischedule、wireguard、Airoha 专属工具（NPU / 风扇 / FlowSense / Factory / Recovery）等
- **精简**：去掉了 lucky、ddns-go、msd_lite、wechatpush（不用或重复）
- **默认开启**：firewall4 软件+硬件 flow offload，BBR

## 设备规格

| 项目 | 参数 |
|------|------|
| SoC | Airoha AN7581GT（4 核 CPU + 8 核 NPU，1.3GHz）|
| 内存 / 闪存 | 2GB / 512MB |
| 网口 | 2×10G RTL8261BE + 2×1G |
| Wi-Fi | MT7996AV BE19000（2.4G/5G/6G 三频，6G 320MHz）|
| 风扇 | PWM（NCT7802 控温）|
| 电源 | 12V 5A |

## 下载

[Releases 页面](https://github.com/NetDoge/ImmortalWrt-XR1710G/releases)

固件文件：`immortalwrt-netdoge-xr1710g-YYYYMMDD-<hash>-airoha-an7581-gemtek_xr1710g-ubi-squashfs-sysupgrade.itb`

升级：LuCI → 系统 → 备份/升级 → 刷写固件

> [!WARNING]
> LuCI 的"保留配置"不会保留额外装的软件包（如 OpenClash）。升级前备份配置、记下已装软件包，升级后重新装；不要恢复旧固件的 `kmod-*` 内核模块。

## 手动触发云编译

Actions → **Build XR1710G Custom Firmware** → Run workflow。

Release 类型选 `release` 或 `prerelease` 才会发 Release；选 `none` 只出 artifact 不发 Release（坑）。

## 本地构建（可选）

```bash
git clone https://github.com/NetDoge/ImmortalWrt-XR1710G.git
cd ImmortalWrt-XR1710G
./scripts/feeds update -a && ./scripts/feeds install -a
bash scripts/fix-stale-golang-host.sh
cp config.seed .config && bash scripts/set-build-version.sh .config
make defconfig
make -j$(nproc) world 2>&1 | tee build.log
bash scripts/summarize-build-errors.sh build.log
```

环境要求：Debian 11+（AMD64），≥4GB RAM，≥25GB 磁盘。

## 结构

- `config.seed` — 完整构建配置（含所有包与默认开关）
- `target/linux/airoha/dts/an7581-xr1710g-ubi.dts` — 独立设备树
- `target/linux/airoha/patches-6.18/`、`target/linux/generic/pending-6.18/` — 内核/网络补丁
- `package/emortal/default-settings/files/99-default-settings` — 首次启动默认配置

## 致谢

- [naoki66/ImmortalWrt-for-Gemtek-XR1710G](https://github.com/naoki66/ImmortalWrt-for-Gemtek-XR1710G) — fork 基础
- [immortalwrt/immortalwrt](https://github.com/immortalwrt/immortalwrt) — ImmortalWrt 主项目
- [rchen14b/luci-app-airoha-npu](https://github.com/rchen14b/luci-app-airoha-npu)、[Gilly1970/Gemtek-W1700K](https://github.com/Gilly1970/Gemtek-W1700K) — 部分应用来源
- [YYH2913/openwrt](https://github.com/YYH2913/openwrt)、[hurrian/openwrt-w1700k](https://github.com/hurrian/openwrt-w1700k)、[lvcdy/openwrt_xr1710g](https://github.com/lvcdy/openwrt_xr1710g) — 移植参考

## 许可证

[GPL-2.0-only](https://spdx.org/licenses/GPL-2.0-only.html)（继承 ImmortalWrt）