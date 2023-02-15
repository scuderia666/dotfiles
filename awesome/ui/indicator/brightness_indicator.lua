local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("modules.helpers")
local dpi = beautiful.xresources.apply_dpi
local rubato = require("modules.rubato")

local args = {
    bg = "#4c587b",

    slider_color = "#e2ebfe",
    slider_hover_color = "#94b4f9",

    emoji = "🔆",
    emoji_color = "#949498",

    disable_line = true
}

return function(s)
    local indicator = require("ui.indicator.indicator")("brightness", s, args)

    local update_slider = function()
        awful.spawn.easy_async_with_shell(
            "brightnessctl | grep -i  'current' | awk '{ print $4}' | tr -d \"(%)\"",
            function(stdout)
                local val = string.gsub(stdout, "^%s*(.-)%s*$", "%1")
                indicator.update(tonumber(val))
            end
        )
    end

    update_slider()

    awesome.connect_signal("update::brightness", function()
        update_slider()
    end)

    awesome.connect_signal("set::brightness", function(value)
        awful.spawn("brightnessctl set " .. value .. "%", false)
    end)
    
    return indicator
end