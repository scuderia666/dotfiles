local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("modules.helpers")
local wibox = require("wibox")
local gears = require("gears")
local util = require("util")
local hover = util.hover

local brightness_module = require("modules.brightness")
local volume_module = require("modules.volume")

awful.screen.connect_for_each_screen(function(s)
    local screen_width = s.geometry.width
    local screen_height = s.geometry.height

    local menu = wibox({
        type = "menu",
        --shape = helpers.rrect(16),
        screen = s,
        width = dpi(480),
        height = dpi(328),
        x = 8,
        y = screen_height - 328 - 36 - 4,
        bg = beautiful.base,
        ontop = true,
        visible = false,
    })
    
    local pfp = {
        widget = wibox.container.background,
        shape = gears.shape.circle,
        align = "center",
        {
            widget = wibox.widget.imagebox,
            image = beautiful.images .. "profile.jpg",
        },
    }

    local user = {
        layout = wibox.layout.stack,
        {
            widget = wibox.container.margin,
            margins = { bottom = 22 },
            pfp
        },
        {
            widget = wibox.container.margin,
            margins = { top = 56 },
            {
                widget = wibox.widget.textbox,
                text = "satou",
                align = "center",
            },
        },
    }

    --[[local slider = wibox.widget.slider() -- ...or any other valid way to create the slider object
    function slider:set_value_direct(value)
        value = math.min(math.max(value, self:get_minimum()), self:get_maximum())
        if value ~= self._private.value then
            self._private.value = value
            self:emit_signal("property::value", value, true) -- Pass an additional `true` value to the callback
            self:emit_signal("widget::redraw_needed")
        end
    end]]--

    local brightness_slider = wibox.widget {
        widget = wibox.widget.slider,
        value = 0,
        maximum = 100,
        forced_width = dpi(400),
        forced_height = dpi(40),
        shape = gears.shape.rounded_bar,
        bar_shape = gears.shape.rounded_bar,
        bar_color = beautiful.surface1,
        bar_margins = {bottom = dpi(18) ,top = dpi(18)},
        bar_active_color = beautiful.crust,
        handle_width = dpi(14),
        handle_shape = gears.shape.circle,
        handle_color = beautiful.green,
        handle_border_width = 0,
        handle_border_color = beautiful.surface2
    }

    local volume_slider = wibox.widget {
        widget = wibox.widget.slider,
        value = 0,
        maximum = 100,
        forced_width = dpi(400),
        forced_height = dpi(40),
        shape = gears.shape.rounded_bar,
        bar_shape = gears.shape.rounded_bar,
        bar_color = beautiful.surface1,
        bar_margins = {bottom = dpi(18) ,top = dpi(18)},
        bar_active_color = beautiful.crust,
        handle_width = dpi(14),
        handle_shape = gears.shape.circle,
        handle_color = beautiful.green,
        handle_border_width = 0,
        handle_border_color = beautiful.surface2
    }

    local brightness_icon = {
        widget = wibox.widget.imagebox,
        image = beautiful.images .. "brightness.svg",
        forced_width = 30,
        forced_height = 30,
    }
    
    local volume_icon = {
        widget = wibox.widget.imagebox,
        image = beautiful.images .. "volume.svg",
        forced_width = 30,
        forced_height = 30,
    }

    local brightness_text = wibox.widget{
        widget = wibox.widget.textbox,
        markup = helpers.colorizeText("0%", beautiful.text),
        font = "Roboto 10",
        align = "center",
        valign = "center"
    }
    
    local volume_text = wibox.widget{
        widget = wibox.widget.textbox,
        markup = helpers.colorizeText("0%", beautiful.text),
        font = "Roboto 10",
        align = "center",
        valign = "center"
    }
    
    local brightness = {
        layout = wibox.layout.stack,
        brightness_icon,
        {
            widget = wibox.container.margin,
            margins = { top = 35 },
            brightness_text
        },
    }
    
    local volume = {
        layout = wibox.layout.stack,
        volume_icon,
        {
            widget = wibox.container.margin,
            margins = { top = 35 },
            volume_text
        },
    }
    
    local minimize = function()
        local tag = awful.screen.focused().selected_tag
        for _, c in pairs(tag:clients()) do
            c.minimized = true
        end
    end
    
    local previous_wallpaper = wibox.widget {
        widget = wibox.container.background,
        shape = helpers.rrect(6),
        forced_width = 40,
        forced_height = 40,
        {
            layout = wibox.layout.align.horizontal,
            spacing = 10,
            {
                widget = wibox.widget.imagebox,
                image = beautiful.images .. "previous.png"
            },
            {
                widget = wibox.container.margin,
                margins = 2,
                {
                    widget = wibox.widget.textbox,
                    text = "Previous wallpaper",
                    font = "Roboto 12",
                },
            },
        },

        buttons = {
            awful.button({}, 1, function()
                minimize()
                awesome.emit_signal("wallpaper::prev")
                end
            ),
        },
    }

    local refresh_icon = wibox.widget{
        widget = wibox.widget.textbox,
        markup = helpers.colorizeText("⟳", beautiful.text),
        font = "Roboto 18",
        align = "center",
        valign = "center"
    }

    local refresh_wallpaper = wibox.widget {
        widget = wibox.container.background,
        shape = helpers.rrect(6),
        forced_width = 40,
        forced_height = 40,
        refresh_icon,
        buttons = {
            awful.button({}, 1, function()
                minimize()
                awesome.emit_signal("wallpaper::refresh")
                end
            ),
        },
    }

    local next_wallpaper = wibox.widget {
        widget = wibox.container.background,
        shape = helpers.rrect(6),
        forced_width = 40,
        forced_height = 40,
        {
            layout = wibox.layout.align.horizontal,
            spacing = 10,
            {
                widget = wibox.container.margin,
                margins = { left = 36 },
                {
                    widget = wibox.widget.textbox,
                    text = "Next wallpaper",
                    font = "Roboto 12",
                },
            },
            nil,
            {
                widget = wibox.widget.imagebox,
                image = beautiful.images .. "next.png",
            },
        },
        buttons = {
            awful.button({}, 1, function()
                minimize()
                awesome.emit_signal("wallpaper::next")
                end
            ),
        },
    }

    helpers.add_hover(previous_wallpaper, beautiful.crust, beautiful.surface0)
    helpers.add_hover(refresh_wallpaper, beautiful.crust, beautiful.surface0)
    helpers.add_hover(next_wallpaper, beautiful.crust, beautiful.surface0)
    
    local poweroff = wibox.widget {
        widget = wibox.widget.textbox,
        font = beautiful.icofont .. " 18",
        align = "center",
        markup = helpers.colorizeText('󰐥', beautiful.red),
        buttons = {
            awful.button({}, 1, function()
                awesome.emit_signal("popup::show")
                menu.visible = false
            end)
        },
    }
    
    local lock = wibox.widget {
        widget = wibox.widget.textbox,
        font = beautiful.icofont .. " 18",
        align = "center",
        markup = helpers.colorizeText('', beautiful.blue),
        buttons = {
            awful.button({}, 1, function()
                awesome.emit_signal("lockscreen::show")
                menu.visible = false
            end)
        },
    }

    menu:setup {
        layout = wibox.layout.fixed.vertical,
        {
            widget = wibox.container.background,
            bg = beautiful.crust,
            forced_height = dpi(84),
            {
                widget = wibox.container.margin,
                margins = { top = 10, right = 10, left = 10 },
                {
                    layout = wibox.layout.align.horizontal,
                    expand = "none",
                    {
                        widget = wibox.widget.textclock
                    },
                    user,
                    {
                        widget = wibox.container.margin,
                        margins = dpi(4),
                        {
                            layout = wibox.layout.align.vertical,
                            spacing = dpi(8),
                            {
                                widget = wibox.container.margin,
                                margins = dpi(4),
                                poweroff
                            },
                            {
                                widget = wibox.container.margin,
                                margins = dpi(4),
                                lock
                            },
                        },
                    },
                },
            },
        },
        {
            widget = wibox.container.margin,
            margins = dpi(12),
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(12),
                brightness,
                brightness_slider
            },
        },
        {
            widget = wibox.container.margin,
            margins = dpi(12),
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(12),
                volume,
                volume_slider
            },
        },
        {
            widget = wibox.container.margin,
            margins = 16,
            {
                layout = wibox.layout.align.horizontal,
                expand = "outside",
                spacing = 10,
                previous_wallpaper,
                {
                    widget = wibox.container.margin,
                    margins = { right = 8, left = 8 },
                    refresh_wallpaper
                },
                next_wallpaper
            },
        },
    }

    function brightness_slider:set_value_direct(value)
        value = math.min(math.max(value, self:get_minimum()), self:get_maximum())
        if value ~= self._private.value then
            self._private.value = value
            self:emit_signal("property::value", value, true)
            self:emit_signal("widget::redraw_needed")
        end
    end

    function volume_slider:set_value_direct(value)
        value = math.min(math.max(value, self:get_minimum()), self:get_maximum())
        if value ~= self._private.value then
            self._private.value = value
            self:emit_signal("property::value", value, true)
            self:emit_signal("widget::redraw_needed")
        end
    end

    brightness_slider:buttons(gears.table.join(
        awful.button({}, 4, nil, function()
            if brightness_slider:get_value() > 100 then
                brightness_slider:set_value(100)
                return
            end
            brightness_slider:set_value(brightness_slider:get_value() + 5)
        end),

        awful.button({}, 5, nil, function()
            if brightness_slider:get_value() < 0 then
                brightness_slider:set_value(0)
                return
            end
            brightness_slider:set_value(brightness_slider:get_value() - 5)
        end)
    ))
    
    volume_slider:buttons(gears.table.join(
        awful.button({}, 4, nil, function()
            if volume_slider:get_value() > 100 then
                volume_slider:set_value(100)
                return
            end

            volume_slider:set_value(volume_slider:get_value() + 5)
        end),

        awful.button({}, 5, nil, function()
            if volume_slider:get_value() < 0 then
                volume_slider:set_value(0)
                return
            end

            volume_slider:set_value(volume_slider:get_value() - 5)
        end)
    ))

    brightness_slider:connect_signal("property::value", function(_, value, direct)
        brightness_text.markup = helpers.colorizeText(value .. "%", beautiful.text)

        if direct then
            return
        else
            brightness_module.set_brightness(value, nil, false)
        end
    end)
    
    volume_slider:connect_signal("property::value", function(_, value, direct)
        volume_text.markup = helpers.colorizeText(value .. "%", beautiful.text)

        if direct then
            return
        else
            volume_module.set_volume(value, false)
        end
    end)

    local update_brightness_slider = function()
        local value = brightness_module.get_brightness()
        if value == nil then
            return
        end
        brightness_slider:set_value_direct(tonumber(value))
    end

    local update_volume_slider = function()
        local value = volume_module.get_volume()
        if value == nil then
            return
        end
        volume_slider:set_value_direct(tonumber(value))
    end

    awesome.connect_signal("update::brightness", function()
        update_brightness_slider()
    end)

    awesome.connect_signal("update::volume", function()
        update_volume_slider()
    end)

    awesome.connect_signal("menu::toggle", function()
        update_brightness_slider()
        update_volume_slider()
        menu.visible = not menu.visible
    end)
end)
