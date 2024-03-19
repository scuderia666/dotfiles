local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")

local helpers = require("modules.helpers")

local wall = require("modules.wall")

local function is_maximized(c)
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
    if c.fullscreen then
        awful.titlebar.hide(c)
    elseif c.floating then
        awful.titlebar.show(c)
    end
end)

client.connect_signal("property::maximized", function(c)
    c.maximized = false
end)

client.connect_signal("property::minimized", function(c)
    c.minimized = false
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

client.connect_signal("request::manage", function(client, context)
    if client.floating and context == "new" then
        client.placement = awful.placement.centered
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

naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification {
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message
	}
end)

--client.connect_signal("property::urgent", function(c) c:jump_to() end)

require("awful.autofocus")

require("ui.bar")
require("ui.better-resize")
require("ui.savefloats")
--require("ui.exitscreen")
require("ui.menu")
require("ui.deco")
require("ui.popup")
require("ui.lockscreen")
--require("ui.indicator")
require("ui.desktop")
require("ui.rightclick")
--require("ui.selrect")

function updateBarsVisibility()
  for s in screen do
    if s.selected_tag then
      local fullscreen = s.selected_tag.fullscreenMode
      s.bar.visible = not fullscreen
    end
  end
end

tag.connect_signal("property::selected", function(t)
  updateBarsVisibility()
end)

client.connect_signal("property::fullscreen", function(c)
  c.first_tag.fullscreenMode = c.fullscreen
  updateBarsVisibility()
end)

client.connect_signal("unmanage", function(c)
  if c.fullscreen then
    c.screen.selected_tag.fullscreenMode = false
    updateBarsVisibility()
  end
end)

awesome.connect_signal("widgets::splash::visibility", function(vis)
	local t = screen.primary.selected_tag
	if vis then
		for idx, c in ipairs(t:clients()) do
			c.hidden = true
		end
	else
		for idx, c in ipairs(t:clients()) do
			c.hidden = false
		end
	end
end)
