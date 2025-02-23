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
##-----------------Del duplicate packages------------------

# 添加外部软件源
git clone -b openwrt https://github.com/zouchanggan/openwrt-packages ./package/small

# 删除依赖(防止插件冲突，删除重复)
rm -rf feeds/packages/net/{lucky,alist,adguardhome,mosdns,xray*,v2ray*,v2ray*,sing*,smartdns}
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/packages/lang/golang
rm -rf feeds/packages/net/chinadns-ng 
rm -rf feeds/packages/net/hysteria 
rm -rf feeds/packages/net/shadowsocksr-libev
rm -rf feeds/packages/net/shadowsocks-rust 
rm -rf feeds/packages/net/shadowsocks-libev 
rm -rf feeds/packages/net/tcping 
rm -rf feeds/packages/net/trojan
rm -rf feeds/packages/net/trojan-go
rm -rf feeds/packages/net/trojan-plus
rm -rf feeds/packages/net/tuic-client  
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/open-app-filter
rm -rf feeds/packages/net/gn && cp -r package/small/gn feeds/packages/net
rm -rf package/libs/mbedtls
rm -rf feeds/packages/net/ddns-go
rm -rf feeds/packages/net/lucky
rm -rf package/small/mihomo

# 更新替换golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang
git clone https://github.com/zouchanggan/mbedtls.git package/libs/mbedtls

# 删除软件包(防止插件冲突，删除重复)
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-passwall2
rm -rf feeds/luci/applications/luci-app-ssr-plus
rm -rf feeds/luci/applications/luci-app-vssr
rm -rf feeds/luci/applications/luci-app-ddns-go
rm -rf feeds/luci/applications/luci-app-appfilter
rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-lucky
rm -rf feeds/luci/applications/luci-app-smartdns
rm -rf feeds/luci/applications/luci-app-alist
rm -rf package/small/luci-app-mihomo
rm -rf package/small/luci-app-homeproxy

# 删除旧主题
rm -rf feeds/luci/themes/luci-theme-argon
# rm -rf package/small/luci-theme-design

##-----------------Add OpenClash dev core------------------
curl -sL -m 30 --retry 2 https://raw.githubusercontent.com/vernesong/OpenClash/core/master/dev/clash-linux-arm64.tar.gz -o /tmp/clash.tar.gz
tar zxvf /tmp/clash.tar.gz -C /tmp >/dev/null 2>&1
chmod +x /tmp/clash >/dev/null 2>&1
mkdir -p package/small/luci-app-openclash/root/etc/openclash/core
mv /tmp/clash package/small/luci-app-openclash/root/etc/openclash/core/clash >/dev/null 2>&1
rm -rf /tmp/clash.tar.gz >/dev/null 2>&1

##-----------------Delete DDNS's examples-----------------
sed -i '/myddns_ipv4/,$d' feeds/packages/net/ddns-scripts/files/etc/config/ddns
##-----------------Manually set CPU frequency for MT7986A-----------------
sed -i '/"mediatek"\/\*|\"mvebu"\/\*/{n; s/.*/\tcpu_freq="2.0GHz" ;;/}' package/emortal/autocore/files/generic/cpuinfo

# 下载源代码&更新feeds 
./scripts/feeds update -a && ./scripts/feeds install -a
