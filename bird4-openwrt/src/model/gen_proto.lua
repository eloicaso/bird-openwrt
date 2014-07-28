--[[ 
Copyright (C) 2014 - Eloi Carbó Solé (GSoC2014) 
BGP/Bird integration with OpenWRT and QMP

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

require("luci.sys")
local http = require "luci.http"
local uci = require "luci.model.uci"
local uciout = uci.cursor()

m=Map("bird4", "Bird4 general protocol's configuration")
kernelNames={}
deviceNames={}
staticNames={}
routeNames={}

-- Optional parameters lists
local protoptions = {
	{["name"]="table", ["help"]="Auxiliar table for routing", ["depends"]={"static","kernel"}},
	{["name"]="import", ["help"]="Set if the protocol must import routes", ["depends"]={"kernel"}},
	{["name"]="export", ["help"]="Set if the protocol must export routes", ["depends"]={"kernel"}},
	{["name"]="scan_time", ["help"]="Time between scans", ["depends"]={"kernel","device"}},
	{["name"]="kernel_table", ["help"]="Set which table must be used as auxiliar kernel table", ["depends"]={"kernel"}},
	{["name"]="learn", ["help"]="Learn routes", ["depends"]={"kernel"}},
	{["name"]="persist", ["help"]="Store routes. After a restart, routes will be still configured", ["depends"]={"kernel"}}
}

local routeroptions = {
	{["name"]="prefix",["help"]="",["depends"]={"router","special","iface","multipath","recursive"}},
	{["name"]="via",["help"]="",["depends"]={"router","multipath"}},
	{["name"]="attribute",["help"]="",["depends"]={"special"}},
	{["name"]="iface",["help"]="",["depends"]={"iface"}},
	{["name"]="ip",["help"]="",["depends"]={"recursive"}}
}

--
-- KERNEL PROTOCOL
--


sect_kernel_protos = m:section(TypedSection, "kernel", "Kernel options", "Configuration of the kernel protocols.")
sect_kernel_protos.addremove = true
sect_kernel_protos.anonymous = false

-- Set names of the protocols

uciout:foreach('bird4', 'kernel', function (s)
	local name = s[".name"]
	if (name ~= nil) then
		table.insert(kernelNames, name)
	end
end)

-- Default kernel parameters

disabled = sect_kernel_protos:option(Flag, "disabled", "Disabled", "If this option is true, the protocol will not be configured.")
disabled.default=0

-- Optional parameters
for _,o in ipairs(protoptions) do
	if o.name ~= nil then
		for _, d in ipairs(o.depends) do
			if d == "kernel" then
				value = sect_kernel_protos:option(Value, o.name, translate(o.name), translate(o.help))
				value.optional = true
				value.rmempty = true
			end
		end

	end
end

--
-- DEVICE PROTOCOL
--

sect_device_protos = m:section(TypedSection, "device", "Device options", "Configuration of the device protocols.")
sect_device_protos.addremove = true
sect_device_protos.anonymous = false

-- Set names of the protocols

uciout:foreach('bird4', 'device', function (s)
    local name = s[".name"]
	    if (name ~= nil) then
			        table.insert(deviceNames, name)
					    end
						end)

-- Default kernel parameters

disabled = sect_device_protos:option(Flag, "disabled", "Disabled", "If this option is true, the protocol will not be configured.")
disabled.default=0

-- Optional parameters
for _,o in ipairs(protoptions) do
	if o.name ~= nil then
		for _, d in ipairs(o.depends) do
			if d == "device" then
				value = sect_device_protos:option(Value, o.name, translate(o.name), translate(o.help))
				value.optional = true
				value.rmempty = true
			end
		end
	end
end
																												
--
-- STATIC PROTOCOL
--

sect_static_protos = m:section(TypedSection, "static", "Static options", "Configuration of the static protocols.")
sect_static_protos.addremove = true
sect_static_protos.anonymous = false

-- Set names of the protocols

uciout:foreach('bird4', 'static', function (s)
	local name = s[".name"]
	if (name ~= nil) then
		table.insert(staticNames, name)
	end
end)

-- Default kernel parameters

disabled = sect_static_protos:option(Flag, "disabled", "Disabled", "If this option is true, the protocol will not be configured.")
disabled.default=0

-- Optional parameters
for _,o in ipairs(protoptions) do
	if o.name ~= nil then
		for _, d in ipairs(o.depends) do
			if d == "static" then
				value = sect_static_protos:option(Value, o.name, translate(o.name), translate(o.help))
				value.optional = true
				value.rmempty = true
			end
		end
	end
end

--
-- ROUTES FOR STATIC PROTOCOL
--


sect_routes = m:section(TypedSection, "route", "Routes configuration", "Configuration of the routes used in static protocols.")
sect_routes.addremove = true
sect_routes.anonymous = false

--sect_routes.sectiontitle = function (self, section)
--	local n = (m.uci:get("bird4", section, "type"))
--	return n.." route:"
--end

instance = sect_routes:option(ListValue, "instance", "Route instance", "")
i = 0
for _,inst in ipairs(staticNames) do
	instance:value("instance", inst)
end

prefix = sect_routes:option(Value, "prefix", "Route prefix", "")

type = sect_routes:option(ListValue, "type", "Type of route", "")
type:value("router")
type:value("special")
type:value("iface")
type:value("recursive")
type:value("multipath")

valueVia = sect_routes:option(Value, "via", "Via", "")
valueVia:depends("type", "router")

listVia = sect_routes:option(StaticList, "l_via", "Via", "")
listVia:depends("type", "multipath")
listVia.optional=false

tabVia = uciout:get_list("bird4", "route", "l_via")
for _, v in ipairs(tabVia) do
	listVia:value(v,v)
end
--tableVia = uciout:get_list("bird4", "route", "via")


attribute = sect_routes:option(Value, "attribute", "Attribute", "Types are: unreachable, prohibit and blackhole")
attribute:depends("type", "special")

iwlist = uciout:get_all("wireless")

iface  = sect_routes:option(ListValue, "iface", "Interface", "")
iface:depends("type", "iface")

for _, v in ipairs(iwlist) do
	if v["type"] == "wifi-iface" then
		iface:value("iface",v["name"])
	end
end

ip =  sect_routes:option(Value, "ip", "IP address", "")
ip:depends("type", "ip")

function m.on_commit(self,map)
        luci.sys.call('/etc/init.d/bird4 stop; /etc/init.d/bird4 start')
end

return m

