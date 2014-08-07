Bird6-OpenWRT
=============

Package for OpenWRT to bring integration with UCI and LUCI to Bird6
(Bird4 at https://github.com/eloicaso/bird4-openwrt)

Dependences: +bird6 +libuci +luci +luci-base +luci-mod-admin-full +uci + libuci-lua

Add also birdc6 to use Bird terminal client.

Important:
=========
/etc/config/bird6 must be configured with your IP addresses and other settings BEFORE executing it. Otherwise, Bird6 may crash.

How to compile:
==============

1. Add this github as a repository in feeds.conf
        src-git bird6wrt https://github.com/eloicaso/bird6-openwrt.git
1.1 Enable OpenWRT-Routing repository to fulfill the dependencies
        src-git routing https://github.com/openwrt-routing/packages.git
2. Update and install the package (in OpenWRT compilation root directory)
        scripts/feeds update -a; scripts/feeds install -a
3a. Compile the whole OpenWRT image with the package included
        make menuconfig -> Network -> Select bird6-openwrt
        make V=99
3b. Compile the packet ( ! this means to compile its dependeces before)
        make /package/feeds/bird6wrt/bird6-openwrt/compile V=99
        make /package/feeds/bird6wrt/bird6-openwrt/install V=99
4. Find your package in
        [OpenWRT_folder]/bin/{Architecture}/packages/bird6-openwrt_{Version}_{Architecture}.ipk
