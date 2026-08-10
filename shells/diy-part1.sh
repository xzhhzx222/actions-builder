#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default


# 添加friendly-bits/geoip-shell
git clone https://github.com/friendly-bits/geoip-shell.git package/friendly-bits/geoip-shell
chmod +x package/friendly-bits/geoip-shell/OpenWrt/prep-owrt-package.sh
package/friendly-bits/geoip-shell/OpenWrt/prep-owrt-package.sh 4
mv -vf "${HOME}/geoip-shell/owrt-build/" "${CUSTOM_DIR}/geoip-shell"
rm -rf package/friendly-bits/

# 修改friendly-bits/geoip-shell
sed -i 's|PKG_SOURCE_VERSION:=.*|PKG_SOURCE_VERSION:=v\$(PKG_VERSION)|' "${CUSTOM_DIR}/geoip-shell/Makefile"
sed -i 's|PKG_SOURCE_URL:=.*|PKG_SOURCE_URL:=https://github.com/friendly-bits/geoip-shell.git|' "${CUSTOM_DIR}/geoip-shell/Makefile"
sed -i '/define Package\/geoip-shell\/postinst\/Default/a exit 0' "${CUSTOM_DIR}/geoip-shell/Makefile"
sed -i 's/return 0/exit 0/g' "${CUSTOM_DIR}/geoip-shell/Makefile"

# 添加stackia/rtp2httpd
git clone https://github.com/stackia/rtp2httpd.git package/stackia/rtp2httpd
mv -vf package/stackia/rtp2httpd/openwrt-support/luci-app-rtp2httpd/ "${CUSTOM_DIR}/"
mv -vf package/stackia/rtp2httpd/openwrt-support/rtp2httpd/ "${CUSTOM_DIR}/"
rm -rf package/stackia/

# 修改stackia/rtp2httpd
# mv -vf "${CUSTOM_DIR}/luci-app-rtp2httpd/Makefile.versioned" "${CUSTOM_DIR}/luci-app-rtp2httpd/Makefile"
mv -vf "${CUSTOM_DIR}/rtp2httpd/Makefile.versioned" "${CUSTOM_DIR}/rtp2httpd/Makefile"

# 添加sirpdboy/luci-app-advanced
git clone https://github.com/sirpdboy/luci-app-advanced.git "${CUSTOM_DIR}/luci-app-advanced"

# 添加fw876/helloworld
# git clone https://github.com/fw876/helloworld.git package/fw876/helloworld
# mv -vf package/fw876/helloworld/*/ "${CUSTOM_DIR}/"
# rm -rf package/fw876

# 添加vernesong/OpenClash
git clone --depth=1 https://github.com/vernesong/OpenClash.git package/vernesong/OpenClash
mv -vf package/vernesong/OpenClash/luci-app-openclash/ "${CUSTOM_DIR}/"
rm -rf package/vernesong/

# 添加Openwrt-Passwall/openwrt-passwall
# git clone https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git package/Openwrt-Passwall/openwrt-passwall-packages
# mv -vf package/Openwrt-Passwall/openwrt-passwall-packages/*/ "${CUSTOM_DIR}/"
# git clone https://github.com/Openwrt-Passwall/openwrt-passwall.git package/Openwrt-Passwall/openwrt-passwall
# mv -vf package/Openwrt-Passwall/openwrt-passwall/luci-app-passwall/ "${CUSTOM_DIR}/"
# git clone https://github.com/Openwrt-Passwall/openwrt-passwall2.git package/Openwrt-Passwall/openwrt-passwall2
# mv -vf package/Openwrt-Passwall/openwrt-passwall2/luci-app-passwall2/ "${CUSTOM_DIR}/"
# rm -rf package/Openwrt-Passwall/

# 添加sirpdboy/luci-app-timecontrol
git clone https://github.com/sirpdboy/luci-app-timecontrol.git "${CUSTOM_DIR}/luci-app-timecontrol"

# 添加tty228/luci-app-wechatpush
git clone https://github.com/tty228/luci-app-wechatpush.git "${CUSTOM_DIR}/luci-app-wechatpush"

# 修改tty228/luci-app-wechatpush
# sed -i 's/\${str_linefeed}/\\\\n/g' "${CUSTOM_DIR}/luci-app-wechatpush/root/usr/share/wechatpush/api/qywx_mpnews.json"
sed -i 's/\${1} ${nowtime}/${nowtime}\\\\n${1}/g' "${CUSTOM_DIR}/luci-app-wechatpush/root/usr/share/wechatpush/api/qywx_mpnews.json"

# 添加sundaqiang/openwrt-packages
git clone https://github.com/sundaqiang/openwrt-packages.git package/sundaqiang/openwrt-packages
mv -vf package/sundaqiang/openwrt-packages/luci-app-wolplus/ "${CUSTOM_DIR}/"
rm -rf package/sundaqiang/

# 修改sundaqiang/luci-app-wolplus
sed -i 's/Wake on LAN/Wake on LAN +/g' "${CUSTOM_DIR}/luci-app-wolplus/luasrc/controller/wolplus.lua"
sed -i 's/wolplus/Wake on LAN +/g' "${CUSTOM_DIR}/luci-app-wolplus/po/zh_Hans/wolplus.po"
sed -i 's/macclient/Host Clients/g' "${CUSTOM_DIR}/luci-app-wolplus/po/zh_Hans/wolplus.po"
sed -i 's/name/Name/g' "${CUSTOM_DIR}/luci-app-wolplus/po/zh_Hans/wolplus.po"
sed -i 's/macaddr/MAC Address/g' "${CUSTOM_DIR}/luci-app-wolplus/po/zh_Hans/wolplus.po"
sed -i 's/maceth/Network Interface/g' "${CUSTOM_DIR}/luci-app-wolplus/po/zh_Hans/wolplus.po"
sed -i 's/awake/Awake/g' "${CUSTOM_DIR}/luci-app-wolplus/po/zh_Hans/wolplus.po"
echo >> "${CUSTOM_DIR}/luci-app-wolplus/po/zh_Hans/wolplus.po"
echo "msgid \"Wake on LAN is a mechanism to remotely boot computers in the local network.\"" >> "${CUSTOM_DIR}/luci-app-wolplus/po/zh_Hans/wolplus.po"
echo "msgstr \"网络唤醒++是一个远程唤醒本地计算机的工具\"" >> "${CUSTOM_DIR}/luci-app-wolplus/po/zh_Hans/wolplus.po"
echo >> "${CUSTOM_DIR}/luci-app-wolplus/po/zh_Hans/wolplus.po"
echo "msgid \"Wake Up Host\"" >> "${CUSTOM_DIR}/luci-app-wolplus/po/zh_Hans/wolplus.po"
echo "msgstr \"唤醒设备\"" >> "${CUSTOM_DIR}/luci-app-wolplus/po/zh_Hans/wolplus.po"

# 添加jerrykuku/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git "${CUSTOM_DIR}/luci-theme-argon"
