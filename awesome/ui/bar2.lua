local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

awful.screen.connect_for_each_screen(function(s)
    local screen_width = s.geometry.width
    local screen_height = s.geometry.height

    --[[s.bar = wibox {
        screen = s,
        width = screen_width,
        height = 20,
        x = 0,
        y = screen_height - 20,
        ontop = true,
        visible = true,
        bg = beautiful.accent
    }]]--
end)