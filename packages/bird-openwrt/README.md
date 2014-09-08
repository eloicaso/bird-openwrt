# Bird4-OpenWRT

Package for OpenWRT to bring integration with UCI and LUCI to Bird4

(Bird6 at https://github.com/eloicaso/bird6-openwrt)

**Dependences**: +bird4 +libuci +luci +luci-base +luci-mod-admin-full +uci + libuci-lua

## Important:

/etc/config/bird4 *must be configured with your IP addresses and other settings BEFORE executing it. Otherwise, Bird4 may crash.*

## How to compile:

* Add this github as a repository in feeds.conf
```
src-git bird4wrt https://github.com/eloicaso/bird4-openwrt.git
```

* Enable OpenWRT-Routing repository to fulfill the dependencies
```
src-git routing https://github.com/openwrt-routing/packages.git
```

* Update and install the package (in OpenWRT compilation root directory)
```
scripts/feeds update -a; scripts/feeds install -a
```

* Compile (Option 1) the whole OpenWRT image with the package included
```
make menuconfig -> Network -> Select bird4-openwrt
make V=99
```

* Compile (Option 2) the packet ( ! this means to compile its dependeces before)
```
make /package/feeds/bird4wrt/bird4-openwrt/compile V=99
make /package/feeds/bird4wrt/bird4-openwrt/install V=99
```

* Find your package in
```
[OpenWRT_folder]/bin/{Architecture}/packages/bird4-openwrt_{Version}_{Architecture}.ipk
```

