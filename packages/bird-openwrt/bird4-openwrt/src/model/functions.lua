--[[
Copyright (C) 2014-2017 - Eloi Carbo

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
]]--

local fs = require "nixio.fs"
local functions_dir = "/etc/bird4/functions/"
local write_file = ""

m = SimpleForm("bird4", "Bird4 Functions", "Bird4 Functions Editor")
m.submit = false
new_function = functions_dir .. os.date("function-%Y%m%d-%H%M")
s = m:section(SimpleSection)
files = s:option(ListValue, "Files", "Function Files:")

-- New File Entry
files:value(new_function, "New File (".. new_function .. ")")
files.default = new_function

local i, file_list = 0, { }
for filename in io.popen("find " .. functions_dir .. " -type f"):lines() do
    i = i + 1
    files:value(filename, filename)
end

ld = s:option(Button, "_load", "Load File")
ld.inputstyle = "reload"

st_file = s:option(DummyValue, "_stfile", "Editing file:")
function st_file.cfgvalue(self, section)
    if ld:formvalue(section) then
        write_file = files:formvalue(section)
        return files:formvalue(section)
    end
    if sv:formvalue(section) then
        sv.write_file = write_file
        return ""
    end
end

area = s:option(Value, "_functions")
area.template = "bird4/tvalue"
area.rows = 20
function area.cfgvalue(self,section)
    if ld:formvalue(section) then
        return fs.readfile(files:formvalue(section))
    else
        return ""
    end
end

sv = s:option(Button, "_save", "Save File")
sv.inputstyle = "apply"
function sv.write(self, section)
    if sv.write_file then
        m.message = sv.write_file
        value = area:formvalue(section):gsub("\r\n?", "\n")
        sv.write_file = ""
        return fs.writefile(write_file, value)
    end
end

return m
