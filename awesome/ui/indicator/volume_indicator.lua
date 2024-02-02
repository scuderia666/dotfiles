local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("modules.helpers")
local dpi = beautiful.xresources.apply_dpi
local rubato = require("modules.rubato")

local volume = require("modules.volume")

local default = {
    bg = "#393A3D",
    line_color = "#A6AEC2",
    emoji = "♪",
    emoji_color = "#949498",
    slider_color = "#D5E2FD",
    slider_hover_color = "#e2ebfe",
}

local red = {
    bg = "#393A3D",
    line_color = "#A6AEC2",
    icon = "volume.svg",
    slider_color = beautiful.blue,
    slider_hover_color = "#e2ebfe",
    disable_line = true,
}

local themes = {
    [1] = default,
    [2] = red,
}

local theme = 1

return function(s)
    local indicator = require("ui.indicator.indicator")("volume", s, themes[theme])

    local update_slider = function()
        awful.spawn.easy_async_with_shell(
            "amixer sget Master | awk -F'[][]' '/Right:|Mono:/ && NF > 1 {sub(/%/, \"\"); printf \"%0.0f\", $2}'",
            function(stdout)
                local val = string.gsub(stdout, "^%s*(.-)%s*$", "%1")
                indicator.update(tonumber(val))
            end
        )
    end

    update_slider()

    awesome.connect_signal("update::volume", function()
        update_slider()
    end)
    
    awesome.connect_signal("set::volume", function(value)
        volume.set_volume(value)
    end)
    
    return indicator
end