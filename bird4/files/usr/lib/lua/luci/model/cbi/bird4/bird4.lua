-- Copyright (C) Eloi Carbó - 2014
-- GSoC 2014 - "BGP/Bird integration with OpenWRT and QMP"

require("luci.sys")
local http = require "luci.http"

m=Map("bird4", "Bird4 general configuration")

local uci = luci.model.uci.cursor()


-- Named section: "bird"

s_bird_uci = m:section(NamedSection, "bird", "bird", "Bird4 file settings", "")
s_bird_uci.addremove = False

uu = s_bird_uci:option(Flag, "useUCIconfig", "Use UCI configuration", "Use UCI configuration instead of the /etc/bird4.conf file")

uf = s_bird_uci:option(Value, "UCIconfigFile", "UCI File", "Specify the file to place the UCI-translated configuration")
uf.default = "/tmp/bird4.conf"

-- Named section: "global"

s_bird_global = m:section(NamedSection, "global", "global", "Global options", "Basic Bird4 settings")
s_bird_global.addremove = False

id = s_bird_global:option(Value, "id", "Router ID", "Identification number of the router. By default, is the router's IP.")

table = s_bird_global:option(Value, "table", "Auxiliar table", "Auxiliar table for routing. Blank means no auxiliar table")

lf = s_bird_global:option(Value, "logFile", "Log File", "File used to store log related data.")

l = s_bird_global:option(MultiValue, "log", "Log", "Set which elements do you want to log.")
l:value("all", "All")
l:value("info", "Info")
l:value("warning","Warning")
l:value("error","Error")
l:value("fatal","Fatal")
l:value("debug","Debug")
l:value("trace","Trace")
l:value("remote","Remote")
l:value("auth","Auth")

d = s_bird_global:option(MultiValue, "debug", "Debug", "Set which elements do you want to debug.")
d:value("all", "All")
d:value("states","States")
d:value("routes","Routes")
d:value("filters","Filters")
d:value("interfaces","Interfaces")
d:value("events","Events")
d:value("packets","Packets")




function m.on_commit(self,map)
        luci.sys.call('/etc/init.d/bird4 stop; /etc/init.d/bird4 start')
end

return m

