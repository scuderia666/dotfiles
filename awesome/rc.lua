local awful = require("awful")
local gears = require("gears")
local filesystem = require("gears.filesystem")

require "setup":generate()

function focused_monitor_name()
    local screen = awful.screen.focused()

    local keys = {}

    for out, _ in pairs(screen.outputs) do
        table.insert(keys, out)
    end
    
    return keys[1]
end

require("theme")
require("ui")
require("rules")
require("keys")
require("autostart")

wall = require("modules.wall")
wall.refresh()
wall.set_wallpaper("dark_pixelart.png")

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

gears.timer({
	timeout = 5,
	autostart = true,
	call_now = true,
	callback = function()
		collectgarbage("collect")
	end,
})
