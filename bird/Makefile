# Copyright (C) 2014 - Eloi Carbó Solé (GSoC2014) 
# BGP/Bird integration with OpenWRT and QMP
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=bird-openwrt
PKG_RELEASE:=1.0
PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

TIMESTAMP := $(shell date -u +%Y%m%d-%H%M)
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
GIT_HASH := $(shell git rev-parse HEAD)

include $(INCLUDE_DIR)/package.mk

define Package/bird-openwrt
	SECTION:=net
	CATEGORY:=Base system
	TITLE:=UCI and LUCI Bird integration
	URL:=https://github.com/eloicaso/bird-openwrt
	DEPENDS:= \
	+bird4 +libuci +luci +luci-base +luci-mod-admin-full +uci + libuci-lua
endef

define Package/bird-openwrt/description
   		Integration of Bird with OpenWRT (UCI+LUCI)
endef

define Package/bird-openwrt/conffiles
/etc/config/bird4
endef

define Build/Prepare
mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/bird-openwrt/install
$(CP) ./files/* $(1)/
$(INSTALL_DIR) $(1)/save
echo "$(TIMESTAMP)" > $(1)/etc/bird-openwrt.version
echo "$(GIT_BRANCH)" >> $(1)/etc/bird-openwrt.version  
echo "$(GIT_HASH)" >> $(1)/etc/bird-openwrt.version
endef

$(eval $(call BuildPackage,bird-openwrt))
