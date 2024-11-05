#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
##-----------------Del duplicate packages------------------
# 删除软件依赖
rm -rf feeds/packages/net/chinadns-ng 
rm -rf feeds/packages/net/hysteria 
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/shadowsocksr-libev
rm -rf feeds/packages/net/shadowsocks-rust 
rm -rf feeds/packages/net/tcping 
rm -rf feeds/packages/net/trojan
rm -rf feeds/packages/net/trojan-go
rm -rf feeds/packages/net/trojan-plus
rm -rf feeds/packages/net/tuic-client  
rm -rf feeds/packages/net/v2raya
rm -rf feeds/packages/net/v2ray-core  
rm -rf feeds/packages/net/v2ray-plugin
rm -rf feeds/packages/net/xray-core 
rm -rf feeds/packages/net/xray-plugin
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/open-app-filter
rm -rf feeds/packages/net/gn
rm -rf feeds/packages/lang/golang
rm -rf package/libs/mbedtls
rm -rf feeds/packages/net/ddns-go
rm -rf feeds/packages/net/lucky

#添加额外软件包
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang
git clone https://github.com/zouchanggan/mbedtls.git package/libs/mbedtls
git clone --depth=1 https://github.com/kenzok8/small.git package/small
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages.git package/passwall-packages
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall.git package/passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2.git package/passwall2
git clone --depth=1 https://github.com/fw876/helloworld.git package/helloworld
git clone https://github.com/zouchanggan/OpenAppFilter.git package/OpenAppFilter
git clone https://github.com/zouchanggan/SSRP.git package/SSRP
git clone https://github.com/gdy666/luci-app-lucky.git package/lucky

# 删除软件包
rm -rf package/passwall-packages/shadowsocks-rust
rm -rf package/passwall-packages/v2ray-geodata
rm -rf package/passwall-packages/chinadns-ng
rm -rf package/passwall-packages/gn
# rm -rf package/passwall-packages/xray-core

# 替换软件&依赖
cp -r package/SSRP/update/v2raya package/passwall-packages
cp -r package/SSRP/themes/luci-theme-design feeds/luci/themes
cp -r package/small/shadowsocks-rust package/passwall-packages
cp -r package/helloworld/luci-app-ssr-plus package/passwall-packages
cp -r package/passwall/luci-app-passwall package/passwall-packages
cp -r package/passwall2/luci-app-passwall2 package/passwall-packages
cp -r package/small/luci-app-mosdns package/passwall-packages
cp -r package/small/mosdns package/passwall-packages
cp -r package/small/v2ray-geodata package/passwall-packages
cp -r package/small/chinadns-ng package/passwall-packages
cp -r package/small/v2dat package/passwall-packages
cp -r package/small/lua-neturl package/passwall-packages
cp -r package/small/redsocks2 package/passwall-packages
cp -r package/small/shadow-tls package/passwall-packages
cp -r package/small/luci-app-openclash package/passwall-packages
cp -r package/small/gn package/passwall-packages
cp -r package/small/gn feeds/packages/net
# cp -r package/SSRP/xray-core package/passwall-packages

# 删除软件包
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-ssr-plus
rm -rf feeds/luci/applications/luci-app-vssr
rm -rf feeds/luci/applications/luci-app-ddns-go
rm -rf feeds/luci/applications/luci-app-appfilter
rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-lucky
rm -rf package/SSRP
rm -rf package/small
rm -rf package/passwall
rm -rf package/passwall2
rm -rf package/helloworld
# 添加 kmod-nf-tproxy 依赖
# sed -i 's/DEPENDS\+=+kmod-ipt-conntrack +IPV6:kmod-nf-conntrack6/DEPENDS\+=+kmod-nf-tproxy +kmod-nf-conntrack +IPV6:kmod-nf-conntrack6/' package/kernel/linux/modules/netfilter.mk
##-----------------Add OpenClash dev core------------------
curl -sL -m 30 --retry 2 https://raw.githubusercontent.com/vernesong/OpenClash/core/master/dev/clash-linux-arm64.tar.gz -o /tmp/clash.tar.gz
tar zxvf /tmp/clash.tar.gz -C /tmp >/dev/null 2>&1
chmod +x /tmp/clash >/dev/null 2>&1
mkdir -p feeds/luci/applications/luci-app-openclash/root/etc/openclash/core
mv /tmp/clash feeds/luci/applications/luci-app-openclash/root/etc/openclash/core/clash >/dev/null 2>&1
rm -rf /tmp/clash.tar.gz >/dev/null 2>&1
##-----------------Delete DDNS's examples-----------------
sed -i '/myddns_ipv4/,$d' feeds/packages/net/ddns-scripts/files/etc/config/ddns
##-----------------Manually set CPU frequency for MT7986A-----------------
sed -i '/"mediatek"\/\*|\"mvebu"\/\*/{n; s/.*/\tcpu_freq="2.0GHz" ;;/}' package/emortal/autocore/files/generic/cpuinfo
# 下载源代码&更新feeds 
./scripts/feeds update -a && ./scripts/feeds install -a
