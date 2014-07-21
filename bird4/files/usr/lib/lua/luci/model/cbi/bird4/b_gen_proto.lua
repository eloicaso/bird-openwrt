-- Copyright (C) Eloi Carbó - 2014
-- GSoC 2014 - "BGP/Bird integration with OpenWRT and QMP"

require("luci.sys")
local http = require "luci.http"


m=Map("bird4", "Bird4 Protocols configuration")

local uci = luci.model.uci.cursor()
local sys = require("luci.sys")


-- Protocol's configuration

uci:foreach('bird4', 'basic_proto', function(s)
                        local name = s[".name"]
                        local type = s.type
                        if (name ~= nil) then
                                if(type ~= nil and type == "static") then
                                        table.insert(static_names, name)
                                end
                        end
                end)
--]]


s_general_protos = m:section(TypedSection, "basic_proto", "Bird4 protocols", "Configuration of the general protocols: Kernel, Device and Static.")
s_general_protos.addremove = true
s_general_protos.anonymous = false

-- Default parameters of the protocols

disabled = s_general_protos:option(Flag, "disabled", "Disabled", "If this option is true, the protocol will not be configured.")
disabled.default = 0

type = s_general_protos:option(ListValue, "type", "Type", "Kernel / Device / Static")
type:value("kernel", "kernel")
type:value("device", "device")
type:value("static", "static")
type.optional = false

-- Optional parameters

local protoptions = {
        {["name"]="table", ["help"]="Auxiliar table for routing", ["depends"]={"static","kernel"}},
        {["name"]="import", ["help"]="Set if the protocol must import routes", ["depends"]={"kernel"}},
        {["name"]="export", ["help"]="Set if the protocol must export routes", ["depends"]={"kernel"}},
        {["name"]="scanTime", ["help"]="Time between scans", ["depends"]={"kernel","device"}},
        {["name"]="tablePriority", ["help"]="Set which table must be used as auxiliar kernel table", ["depends"]={"kernel"}},
        {["name"]="learn", ["help"]="Learn routes", ["depends"]={"kernel"}},
        {["name"]="persist", ["help"]="Store routes. After a restart, routes will be still configured", ["depends"]={"kernel"}},
        {["name"]="primary", ["help"]="Set which routes have preference. <br>Use @IP. Ex: '172.16.1.2'", ["depends"]={"device"}},
        {["name"]="primaryIface", ["help"]="Set which interfaces have preference. <br>Use interface:@IP. Ex: 'eth0:172.16.1.2'", ["depends"]={"device"}}
}



for _,o in ipairs(protoptions) do
        if o.name ~= nil then
                value = s_general_protos:option(Value, o.name, translate(o.name), translate(o.help))
                value.optional = true
                value.rmempty = true
                for _,d in ipairs(o.depends) do
                        if (d == "kernel") then
                        value:depends("type","kernel")
                        end
                        if (d == "static") then
                        value:depends("type","static")
                        end
                        if (d == "device") then
                        value:depends("type","device")
                        end
                end
        end
end



function m.on_commit(self,map)
        luci.sys.call('/etc/init.d/bird4 stop; /etc/init.d/bird4 start')
end

return m

