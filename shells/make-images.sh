#!/bin/bash
#==========================================================================
# https://github.com/xzhhzx222/actions-builder
#==========================================================================

sed -i 's/CONFIG_TARGET_ROOTFS_TARGZ=.*/# CONFIG_TARGET_ROOTFS_TARGZ is not set/g' .config
sed -i 's/CONFIG_ISO_IMAGES=.*/# CONFIG_ISO_IMAGES is not set/g' .config
sed -i 's/CONFIG_QCOW2_IMAGES=.*/# CONFIG_QCOW2_IMAGES is not set/' .config
sed -i 's/CONFIG_VDI_IMAGES=.*/# CONFIG_VDI_IMAGES is not set/' .config
sed -i 's/CONFIG_VMDK_IMAGES=.*/# CONFIG_VMDK_IMAGES is not set/' .config
sed -i 's/CONFIG_VHDX_IMAGES=.*/# CONFIG_VHDX_IMAGES is not set/' .config
sed -i 's/CONFIG_JSON_OVERVIEW_IMAGE_INFO=.*/# CONFIG_JSON_OVERVIEW_IMAGE_INFO is not set/' .config
sed -i 's/CONFIG_JSON_CYCLONEDX_SBOM=.*/# CONFIG_JSON_CYCLONEDX_SBOM is not set/' .config

CLASH_DIR="files/etc/openclash"

echo "::group::vernesong/OpenClash"
# 修改vernesong/OpenClash
mkdir -p ${CLASH_DIR}
curl -Ls -o "${CLASH_DIR}/GeoIP.dat" https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
curl -Ls -o "${CLASH_DIR}/GeoSite.dat" https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
curl -Ls -o "${CLASH_DIR}/china_ip_route.ipset" https://raw.githubusercontent.com/gaoyifan/china-operator-ip/refs/heads/ip-lists/china.txt
curl -Ls -o "${CLASH_DIR}/china_ip6_route.ipset" https://raw.githubusercontent.com/gaoyifan/china-operator-ip/refs/heads/ip-lists/china6.txt
curl -Ls -o "${CLASH_DIR}/Country.mmdb" https://raw.githubusercontent.com/alecthw/mmdb_china_ip_list/release/lite/Country.mmdb
curl -Ls -o "${CLASH_DIR}/ASN.mmdb" https://raw.githubusercontent.com/xishang0128/geoip/release/GeoLite2-ASN.mmdb
mkdir -p "${CLASH_DIR}/core"
curl -Ls -o "${CLASH_DIR}/core/core.tar.gz" https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-amd64-compatible.tar.gz
tar -zxf "${CLASH_DIR}/core/core.tar.gz" -C "${CLASH_DIR}/core"
mv -vf "${CLASH_DIR}/core/clash" "${CLASH_DIR}/core/clash_meta"
rm -vf "${CLASH_DIR}/core/core.tar.gz"
echo "::endgroup::"

echo "::group::make info"
make info
echo "::endgroup::"

CUSTOM_PKG="\
  -kmod-8139cp -kmod-8139too -kmod-amazon-ena -kmod-bnx2 -kmod-dwmac-intel \
  -kmod-forcedeth -kmod-pcnet32 -kmod-r8101 -kmod-tulip -kmod-usb-net-rtl8150 \
  \
  -default-settings -default-settings-chn \
  \
  autocore htop iperf3 tree vim-full \
  \
  luci \
  \
  luci-app-ddns luci-app-ramfree \
  \
  luci-i18n-base-zh-cn luci-i18n-ddns-zh-cn luci-i18n-firewall-zh-cn \
  luci-i18n-package-manager-zh-cn luci-i18n-ramfree-zh-cn \
  "
CUSTOM_PKG="${CUSTOM_PKG} \
  kmod-crypto-ecdh kmod-crypto-gcm kmod-crypto-sha256 kmod-inet-diag \
  kmod-nft-tproxy \
  \
  strongswan-charon strongswan-mod-aes strongswan-mod-attr \
  strongswan-mod-eap-identity strongswan-mod-eap-mschapv2 strongswan-mod-gcm \
  strongswan-mod-gmp strongswan-mod-hmac strongswan-mod-kernel-netlink \
  strongswan-mod-mgf1 strongswan-mod-openssl strongswan-mod-pem \
  strongswan-mod-pkcs1 strongswan-mod-pkcs12 strongswan-mod-pubkey \
  strongswan-mod-random strongswan-mod-rc2 strongswan-mod-sha2 \
  strongswan-mod-socket-default strongswan-mod-x509 strongswan-pki \
  strongswan-swanctl \
  \
  acme-acmesh-dnsapi ddns-scripts-cloudflare qemu-ga \
  \
  luci-app-timewol \
  \
  luci-i18n-timewol-zh-cn \
  \
  luci-proto-xfrm \
  "
CUSTOM_PKG="${CUSTOM_PKG} \
  geoip-shell \
  \
  luci-app-advanced luci-app-openclash luci-app-rtp2httpd luci-app-wechatpush \
  luci-app-wolplus \
  \
  luci-i18n-rtp2httpd-zh-cn luci-i18n-wechatpush-zh-cn luci-i18n-wolplus-zh-cn \
  "

echo "::group::make image"
make image PROFILE="${TARGET_PROFILE}" PACKAGES="${CUSTOM_PKG}" \
  FILES="files" ROOTFS_PARTSIZE="300"
echo "::endgroup::"
