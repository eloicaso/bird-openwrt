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

m=Map("bird6", "Bird6 BGP protocol's configuration")

tab_templates = {}
uciout:foreach('bird6', 'bgp_template', function (s)
	local name = s[".name"]
	if (name ~= nil) then
		table.insert(tab_templates, name)
	end
end)

-- Section BGP Templates

sect_templates = m:section(TypedSection, "bgp_template", "BGP Templates", "Configuration of the templates used in BGP instances.")
sect_templates.addremove = true
sect_templates.anonymous = false

disabled = sect_templates:option(Flag, "disabled", "Disabled", "Enable/Disable BGP Protocol")
disabled.optional=true
table = sect_templates:option(ListValue, "table", "Table", "Set the table used for BGP Routing")
table.optional=true
uciout:foreach("bird6", "table",
	function (s)
		table:value(s.name)
	end)
table:value("")

import = sect_templates:option(Value, "import", "Import","")
import.optional=true
export = sect_templates:option(Value, "export", "Export", "")
export.optional=true
local_address = sect_templates:option(Value, "local_address", "Local BGP address", "")
local_address.optional=true
local_as = sect_templates:option(Value, "local_as", "Local AS", "")
local_as.optional=true

-- Section BGP Instances:

sect_instances = m:section(TypedSection, "bgp", "BGP Instances", "Configuration of the BGP protocol instances")
sect_instances.addremove = true
sect_instances.anonymous = false

templates = sect_instances:option(ListValue, "template", "Templates", "Available BGP templates")

uciout:foreach("bird6", "bgp_template",
	function(s)
		templates:value(s[".name"])
	end)
templates:value("")
neighbor_address = sect_instances:option(Value, "neighbor_address", "Neighbor IP Address", "")
neighbor_as = sect_instances:option(Value, "neighbor_as", "Neighbor AS", "")

disabled = sect_instances:option(Flag, "disabled", "Disabled", "Enable/Disable BGP Protocol")
disabled.optional=true
disabled.default=nil
table = sect_instances:option(ListValue, "table", "Table", "Set the table used for BGP Routing")
table.optional=true
uciout:foreach("bird6", "table",
    function (s)
	        table:value(s.name)
			    end)
table:value("")

import = sect_instances:option(Value, "import", "Import","")
import.optional=true
export = sect_instances:option(Value, "export", "Export", "")
export.optional=true
local_address = sect_instances:option(Value, "local_address", "Local BGP address", "")
local_address.optional=true
local_as = sect_instances:option(Value, "local_as", "Local AS", "")
local_as.optional=true

-- Section BGP Filters

sect_filters = m:section(TypedSection, "filter", "BGP Filters", "Filters of the BGP instances")
sect_filters.addremove = true
sect_filters.anonymous = false
sect_filters:depends("type", "bgp")

instance = sect_filters:option(ListValue, "instance", "BGP instance", "Filter's BGP instance")
instance:depends("type", "bgp")

uciout:foreach("bird6", "bgp",
	function (s)
		instance:value(s[".name"])
	end)

type = sect_filters:option(Value, "type", "Filter type", "")
type.default = "bgp"

path = sect_filters:option(Value, "file_path", "Filter's file path", "Path to the Filter's file")
path:depends("type", "bgp")

function m.on_commit(self,map)
        luci.sys.call('/etc/init.d/bird6 stop; /etc/init.d/bird6 start')
end

return m

