local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local hover = {}

hover.add = function(widget)
    widget:connect_signal("mouse::enter", function()
        widget.bg = beautiful.bg3
    end)

    widget:connect_signal("mouse::leave", function()
        widget.bg = beautiful.bg
    end)

    widget:connect_signal("button::press", function()
        widget.bg = beautiful.bg2
    end)
    
    widget:connect_signal("button::release", function()
        widget.bg = beautiful.bg3
    end)
end

return hover