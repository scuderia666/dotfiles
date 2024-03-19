local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")

local helpers = require("modules.helpers")

local wall = require("modules.wall")

awful.screen.connect_for_each_screen(function(s)
    awful.tag({"1", "2", "3", "4"}, s, awful.layout.layouts[2])
end)

client.connect_signal("property::maximized", function(c)
    c.maximized = false
end)

client.connect_signal("property::minimized", function(c)
    c.minimized = false
end)

client.connect_signal("property::floating", function(c)
	if c.floating and c.name ~= "Discord Updater" and c.role ~= "Popup" then
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
require("ui.menu")
require("ui.deco")
require("ui.popup")
require("ui.lockscreen")
require("ui.indicator")
require("ui.desktop")
require("ui.rightclick")

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
