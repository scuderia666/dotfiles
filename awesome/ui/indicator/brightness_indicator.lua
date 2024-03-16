local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("modules.helpers")
local dpi = beautiful.xresources.apply_dpi
local rubato = require("modules.rubato")

local brightness = require("modules.brightness")

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
        local value = brightness.get_brightness()
        indicator.update(tonumber(value))
    end

    update_slider()

    awesome.connect_signal("update::brightness", function()
        update_slider()
    end)

    awesome.connect_signal("set::brightness", function(value)
        brightness.set_brightness(value)
    end)
    
    return indicator
end
