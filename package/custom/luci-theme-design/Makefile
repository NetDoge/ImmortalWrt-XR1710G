# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Design Theme
LUCI_DEPENDS:=
# ImmortalWrt master 使用 APK 打包，版本串只允许一个「-rNNN」后缀；
# 旧的 PKG_VERSION:=5.8.0-20240106 会被 luci.mk 拼成 5.8.0-20240106-r1
# （两个连字符），apk mkpkg 报 package version is invalid。拆成 VERSION+RELEASE。
PKG_VERSION:=5.8.0
PKG_RELEASE:=20240106

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
