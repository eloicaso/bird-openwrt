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

m=Map("bird4", "Bird4 BGP protocol's configuration")


--
-- BGP Templates
--
tab_templates = {}
uciout:foreach('bird4', 'bgp_template', function (s)
	local name = s[".name"]
	if (name ~= nil) then
		table.insert(tab_templates, name)
	end
end)


sect_templates = m:section(TypedSection, "bgp_template", "BGP Templates", "Configuration of the templates used in BGP instances.")
sect_templates.addremove = true
sect_templates.anonymous = false

disabled = sect_templates:option(Flag, "disabled", "Disabled", "Enable/Disable BGP Protocol")
disabled.optional=true
table = sect_templates:option(Value, "table", "Table", "Set the table used for BGP Routing")
table.optional=true
import = sect_templates:option(Value, "import", "Import","")
import.optional=true
export = sect_templates:option(Value, "export", "Export", "")
export.optional=true
local_address = sect_templates:option(Value, "local_address", "Local BGP address", "")
local_address.optional=true
local_as = sect_templates:option(Value, "local_as", "Local AS", "")
local_as.optional=true

sect_instances = m:section(TypedSection, "bgp", "BGP Instances", "Configuration of the BGP protocol instances")
sect_instances.addremove = true
sect_instances.anonymous = false

templates = sect_instances:option(ListValue, "template", "Templates", "Available BGP templates")

for _, v in ipairs(tab_templates) do
	templates:value("template", v)
end


neighbor_address = sect_instances:option(Value, "neighbor_address", "Neighbor IP Address", "")
neighbor_as = sect_instances:option(Value, "neighbor_as", "Neighbor AS", "")

disabled = sect_instances:option(Flag, "disabled", "Disabled", "Enable/Disable BGP Protocol")
disabled.optional=true
disabled.default=nil
table = sect_instances:option(Value, "table", "Table", "Set the table used for BGP Routing")
table.optional=true
import = sect_instances:option(Value, "import", "Import","")
import.optional=true
export = sect_instances:option(Value, "export", "Export", "")
export.optional=true
local_address = sect_instances:option(Value, "local_address", "Local BGP address", "")
local_address.optional=true
local_as = sect_instances:option(Value, "local_as", "Local AS", "")
local_as.optional=true



function m.on_commit(self,map)
        luci.sys.call('/etc/init.d/bird4 stop; /etc/init.d/bird4 start')
end

return m

