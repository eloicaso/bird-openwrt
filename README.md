# bird-openwrt

Package for OpenWRT to bring integration with UCI and LUCI to Bird4 and Bird6 daemon.

This repository contains an UCI module adding support for an user-friendly configuration of the BIRD daemon in OpenWRT systems and a LuCI application to control this UCI configuration using the web-based OpenWRT configuration system.

**Dependences**: +bird\* +libuci +luci-base +uci +libuci-lua

## Important:

/etc/config/bird\* *MUST be configured with your correct settings BEFORE executing it. Otherwise, Bird may crash.*

## How to compile:
Due to the existence of Routing's bird-openwrt packages, if you want to build your system using this repo's bird packages, you need to proceed as follows:


* Add this github as a repository in feeds.conf. Alternatively, you could use a local git clone)
```
src-git birdwrt https://github.com/eloicaso/bird-openwrt.git

```
OR
```
src-link birdwrt /path/to/your/git/clone/bird-openwrt
```


* Update and install all packages in feeds
```
./scripts/feeds update -a; ./scripts/feeds install -a
```

* Enable OpenWRT-Routing repository to fulfill bird{4/6} dependencies
```
src-git routing https://github.com/openwrt-routing/packages.git
./scripts/feeds update routing; ./scripts/feeds install bird4 bird6
```

* Compile (Option 1) the whole OpenWRT image with the package included
```
make menuconfig -> Network -> Routing and Redirection -> Select bird*-uci
                -> LuCI -> 3. Applications -> Select luci-app-bird*
make V=99
```

* Compile (Option 2) the packet ( ! this method requires to compile its dependeces before using Option 1)
```
make package/feeds/birdwrt/bird{4/6}-openwrt/compile V=99
```

* Find your package in
```
[OpenWRT_folder]/bin/packages/{Architecture}/routing/bird{4/6}-uci_{Version}_{Architecture}.ipk
[OpenWRT_folder]/bin/packages/{Architecture}/routing/luci-app-bird{4/6}_{Version}_{Architecture}.ipk
```
