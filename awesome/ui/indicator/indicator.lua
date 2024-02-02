local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("modules.helpers")
local dpi = beautiful.xresources.apply_dpi
local rubato = require("modules.rubato")

local value = 0

local default_args = {
    bg = "#393A3D",

    slider_color = "#D5E2FD",
    slider_hover_color = "#A6AEC2",
    
    icon = "",

    emoji = "",
    emoji_color = "#949498",
    emoji_font = beautiful.icofont,
    emoji_size = 18,

    disable_line = false,
    line_color = "#A6AEC2",
}

return function(name, s, args)
    args = helpers.tableMerge(default_args, args)

    local screen_width = s.geometry.width
    local screen_height = s.geometry.height

    local width = 60
    local height = 220

    local indicator = wibox({
        shape = helpers.rrect(46),
        screen = s,
        width = width,
        height = height,
        x = screen_width - width - 8,
        y = screen_height/2 - height/2,
        bg = args.bg,
        ontop = true,
        visible = false,
    })
    
    local emoji = {
        widget = wibox.widget.textbox,
        markup = helpers.colorizeText(args.emoji, args.emoji_color),
        font = args.emoji_font .. " " .. args.emoji_size,
        align = "center",
        valign = "top",
    }

    local icon = wibox.widget {
        widget = wibox.widget.imagebox,
        image = beautiful.images .. "/" .. args.icon,
        align = "center",
        valign = "top",
    }

    local choose
    
    if args.icon ~= "" then
        choose = icon
    else
        choose = emoji
    end

    local slider = wibox.widget {
        widget = wibox.container.background,
        shape = helpers.rrect(32),
        {
            widget = wibox.container.margin,
            margins = { top = 8 },
            choose,
        },
    }
    
    helpers.add_hover(slider, args.slider_color, args.slider_hover_color)

    local occupy = wibox.widget {
        widget = wibox.container.margin,
        {
            widget = wibox.container.background,
            visible = false
        },

        buttons = {
            awful.button({}, 1, function()
                indicator.visible = false
            end)
        }
    }

    local timer_die = timer { timeout = 3 }

    slider:connect_signal("mouse::enter", function()
        timer_die:stop()
    end)

    slider:connect_signal("mouse::leave", function()
        timer_die:start()
    end)

    local set = function(val)
        if val > 100 then
            val = 100
        elseif val < 0 then
            val = 0
        end

        local old_ratio = 100/value
        local ratio = 100/val

        timed = rubato.timed {
            intro = 0.1,
            duration = 0.3,
            easing = rubato.quadratic,
            pos = 160 - 160/old_ratio,
            subscribed = function(val)
                occupy.top = val
            end
        }

        value = val
        timed.target = 160 - 160/ratio
        icon.top = 180 - 160/ratio
        awesome.emit_signal("set::" .. name, value)
    end
    
    local sett = function(val)
        if val > 100 then
            val = 100
        elseif val < 0 then
            val = 0
        end
        local old_ratio = 100/value
        local ratio = 100/val
        value = val
        occupy.top = 160 - 160/ratio
        icon.top = 180 - 160/ratio
        awesome.emit_signal("set::" .. name, value)
    end

    slider:buttons {
        awful.button({}, 4, function()
            set(value + 5)
        end),

        awful.button({}, 5, function()
            set(value - 5)
        end),
    }
    
    indicator.update = function(val)
        if not value == val then
            local diff

            if val > tonumber(value) then
                diff = val - tonumber(value)
            elseif tonumber(value) > val then
                diff = tonumber(value) - val
            end

            value = val
            sett(100 - diff)
        else
            sett(val)
        end
    end

    local line

    if not args.disable_line then
        line = {
            widget = wibox.container.margin,
            margins = dpi(28),
            {
                widget = wibox.container.background,
                shape = helpers.rrect(32),
                bg = args.line_color
            },
        }
    end

    indicator:setup {
        layout = wibox.layout.stack,
        line,
        {
            widget = wibox.container.margin,
            margins = dpi(8),
            {
                layout = wibox.layout.align.vertical,
                occupy,
                slider,
            },
        },
    }

    indicator.show = function()
        if timer_die.started then
            timer_die:again()
        else
            timer_die:start()
        end

        indicator.visible = true
    end
    
    indicator.hide = function()
        indicator.visible = false

        if timer_die.started then
            timer_die:stop()
        end
    end

    timer_die:connect_signal("timeout", function()
        indicator.hide()
    end)

    awesome.connect_signal("show_indicator::" .. name, function()
        indicator.show()
    end)
    
    awesome.connect_signal("hide_indicator::" .. name, function()
        indicator.hide()
    end)
    
    return indicator
end