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
        type = "dock",
        shape = helpers.rrect(16),
        screen = s,
        width = dpi(480),
        height = dpi(400),
        x = 8,
        y = screen_height - 452,
        bg = beautiful.bg3,
        ontop = true,
        visible = false,
    })
    
    local pfp = {
        widget = wibox.container.background,
        shape = gears.shape.circle,
        align = "center",
        {
            widget = wibox.widget.imagebox,
            image = beautiful.images .. "/profile.jpg",
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

    local brightness_slider = wibox.widget {
        widget = wibox.widget.slider,
        value = 0,
        maximum = 100,
        forced_width = dpi(400),
        forced_height = dpi(40),
        shape = gears.shape.rounded_bar,
        bar_shape = gears.shape.rounded_bar,
        bar_color = beautiful.bg4,
        bar_margins = {bottom = dpi(18) ,top = dpi(18)},
        bar_active_color = beautiful.bg,
        handle_width = dpi(14),
        handle_shape = gears.shape.circle,
        handle_color = beautiful.red,
        handle_border_width = 3,
        handle_border_color = beautiful.bg3
    }

    local volume_slider = wibox.widget {
        widget = wibox.widget.slider,
        value = 0,
        maximum = 100,
        forced_width = dpi(400),
        forced_height = dpi(40),
        shape = gears.shape.rounded_bar,
        bar_shape = gears.shape.rounded_bar,
        bar_color = beautiful.bg4,
        bar_margins = {bottom = dpi(18) ,top = dpi(18)},
        bar_active_color = beautiful.bg,
        handle_width = dpi(14),
        handle_shape = gears.shape.circle,
        handle_color = beautiful.red,
        handle_border_width = 3,
        handle_border_color = beautiful.bg3
    }

    local brightness_icon = {
        widget = wibox.widget.imagebox,
        image = beautiful.images .. "/brightness.svg",
        forced_width = 30,
        forced_height = 30,
    }
    
    local volume_icon = {
        widget = wibox.widget.imagebox,
        image = beautiful.images .. "/volume.svg",
        forced_width = 30,
        forced_height = 30,
    }

    local brightness_text = wibox.widget{
        widget = wibox.widget.textbox,
        markup = helpers.colorizeText("0%", beautiful.fg),
        font = "Roboto 10",
        align = "center",
        valign = "center"
    }
    
    local volume_text = wibox.widget{
        widget = wibox.widget.textbox,
        markup = helpers.colorizeText("0%", beautiful.fg),
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
        bg = beautiful.bg,
        shape = helpers.rrect(6),
        forced_width = 40,
        forced_height = 40,
        {
            layout = wibox.layout.align.horizontal,
            spacing = 10,
            {
                widget = wibox.widget.imagebox,
                image = beautiful.images .. "/previous.png"
            },
            {
                widget = wibox.container.margin,
                margins = 8,
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

    local next_wallpaper = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.bg,
        shape = helpers.rrect(6),
        forced_width = 40,
        forced_height = 40,
        {
            layout = wibox.layout.align.horizontal,
            spacing = 10,
            {
                widget = wibox.container.margin,
                margins = { left = 38 },
                {
                    widget = wibox.widget.textbox,
                    text = "Next wallpaper",
                    font = "Roboto 12",
                },
            },
            nil,
            {
                widget = wibox.widget.imagebox,
                image = beautiful.images .. "/next.png",
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

    helpers.add_hover(previous_wallpaper, beautiful.bg, beautiful.bg_3)
    helpers.add_hover(next_wallpaper, beautiful.bg, beautiful.bg_3)

    menu:setup {
        layout = wibox.layout.fixed.vertical,
        {
            widget = wibox.container.background,
            bg = beautiful.bg,
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
                                widget = wibox.widget.textbox,
                                font = beautiful.icofont .. " 18",
                                markup = helpers.colorizeText('󰐥', beautiful.err),
                                buttons = {
                                    awful.button({}, 1, function()
                                        awesome.emit_signal("popup::show")
                                        menu.visible = false
                                    end)
                                },
                            },
                            {
                                widget = wibox.widget.textbox,
                                font = beautiful.icofont .. " 18",
                                markup = helpers.colorizeText('', beautiful.blue),
                                buttons = {
                                    awful.button({}, 1, function()
                                        awesome.emit_signal("lockscreen::show")
                                        menu.visible = false
                                    end)
                                },
                            }
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
                layout = wibox.layout.flex.horizontal,
                spacing = 20,
                previous_wallpaper,
                next_wallpaper
            },
        },
    }
    
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

    brightness_slider:connect_signal("property::value", function(_, new_value)
        brightness_text.markup = helpers.colorizeText(new_value .. "%", beautiful.fg)
        brightness_slider.value = new_value
        brightness_module.set_brightness(new_value)
    end)
    
    volume_slider:connect_signal("property::value", function()
        local volume_level = volume_slider:get_value()
        volume_text.markup = helpers.colorizeText(volume_level .. "%", beautiful.fg)
        volume_slider.value = volume_level
        volume_module.set_volume(volume_level)
    end)

    local update_brightness_slider = function()
        local value = string.gsub("100", "^%s*(.-)%s*$", "%1")
        brightness_slider:set_value(tonumber(value))
        brightness_text.text = value .. "%"
    end

    local update_volume_slider = function()
        awful.spawn.easy_async_with_shell(
            "amixer sget Master | awk -F'[][]' '/Right:|Mono:/ && NF > 1 {sub(/%/, \"\"); printf \"%0.0f\", $2}'",
            function(stdout)
                local value = string.gsub(stdout, "^%s*(.-)%s*$", "%1")
                volume_slider:set_value(tonumber(value))
                volume_text.text = value .. "%"
            end
        )
    end

    update_brightness_slider()
    update_volume_slider()

    awesome.connect_signal("update::brightness", function()
        update_brightness_slider()
    end)

    awesome.connect_signal("update::volume", function()
        update_volume_slider()
    end)

    awesome.connect_signal("menu::toggle", function()
        if not menu.visible then
            update_brightness_slider()
            update_volume_slider()
        end
        menu.visible = not menu.visible
    end)
end)