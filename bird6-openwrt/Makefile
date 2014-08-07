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

PKG_NAME:=bird6-openwrt
PKG_RELEASE:=0.1
PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  TITLE:=UCI and LUCI Bird6 integration
  SECTION:=net
  CATEGORY:=Network
  MAINTAINER:=Eloi Carbo <eloicaso@openmailbox.org>
  URL:=https://github.com/eloicaso/bird6-openwrt/
  DEPENDS:=+bird6 +libuci +luci +luci-base +luci-mod-admin-full +uci +libuci-lua
endef

define Package/$(PKG_NAME)/description
	Integration of Bird6 with OpenWRT (UCI+LUCI)
endef

define Package/$(PKG_NAME)/conffiles
	/etc/config/bird6
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/bird6/
	$(INSTALL_BIN) ./src/init.d/bird6 $(1)/etc/init.d/bird6
	$(CP) ./src/config/bird6 $(1)/etc/config/
	$(CP) ./src/model/* $(1)/usr/lib/lua/luci/model/cbi/bird6/
	$(CP) ./src/controller/* $(1)/usr/lib/lua/luci/controller/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
