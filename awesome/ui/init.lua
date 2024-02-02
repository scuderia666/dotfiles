local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local helpers = require('modules.helpers')

local function is_maximized(c)

	-- if window fills screen, remove rounded corners and translucent borders
	local function _fills_screen()
		local wa = c.screen.workarea
		local cg = c:geometry()
		return wa.x == cg.x and wa.y == cg.y and wa.width == cg.width and wa.height == cg.height
	end

	return c.maximized or (not c.floating and _fills_screen())
end

local function round_corners(c)
    if not c.fullscreen and not is_maximized(c) then
        c.shape = helpers.rrect(beautiful.rounded)
    else
        c.shape = gears.shape.rectangle
    end
end

awful.screen.connect_for_each_screen(function(s)
	awful.tag({"1", "2", "3", "4"}, s, awful.layout.layouts[2])
end)

client.connect_signal("property::fullscreen", function(c)
    round_corners(c)
end)
client.connect_signal("property::maximized", function(c)
    c.maximized = false
end)
client.connect_signal("property::minimized", function(c)
    c.minimized = false
end)
client.connect_signal("manage", function(c)
    round_corners(c)
end)

client.connect_signal("property::floating", function(c)
    if c.floating then
        c.ontop = true
        awful.titlebar.show(c)
    else
        c.ontop = false
        awful.titlebar.hide(c)
    end
end)

screen.connect_signal("arrange", function(s)
    local only_one = #s.tiled_clients == 1

    for _, c in pairs(s.clients) do
        if not only_one and not c.floating and not c.fullscreen then
            c.border_width = beautiful.border_width
        else
            c.border_width = 0
        end
    end
end)

--client.connect_signal("property::urgent", function(c) c:jump_to() end)

require("awful.autofocus")

require("ui.bar")
require("ui.better-resize")
require("ui.savefloats")
require("ui.exitscreen")
require("ui.menu")
require("ui.deco")
require("ui.popup")
require("ui.lockscreen")
require("ui.indicator")
require("ui.desktop")
require("ui.rightclick")
--require("ui.selrect")