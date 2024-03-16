local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local hover = {}

hover.add = function(widget)
    widget:connect_signal("mouse::enter", function()
        widget.bg = beautiful.surface2
    end)

    widget:connect_signal("mouse::leave", function()
        widget.bg = beautiful.base
    end)

    widget:connect_signal("button::press", function()
        widget.bg = beautiful.surface1
    end)
    
    widget:connect_signal("button::release", function()
        widget.bg = beautiful.surface2
    end)
end

return hover