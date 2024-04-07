local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("modules.helpers")
local dpi = beautiful.xresources.apply_dpi
local rubato = require("modules.rubato")

local exclude = {
    "Shift_R",
    "Shift_L",
    "Super_R",
    "Super_L",
    "Tab",
    "Alt_R",
    "Alt_L",
    "Ctrl_L",
    "Ctrl_R",
    "CapsLock",
    "Home",
    "Down",
    "Up",
    "Left",
    "Right"
}

local function has_value(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
end

return function(s)

    local screen_width = s.geometry.width
    local screen_height = s.geometry.height

    local width = 300
    local height = 200

    local indicator = wibox({
        type = "tooltip",
        screen = s,
        width = 300,
        height = screen_height - 36,
        x = screen_width - 300,
        y = 0,
        bg = beautiful.base .. "00",
        ontop = true,
        visible = false,
    })

    local notiflist = wibox.widget {
        widget = wibox.layout.fixed.vertical,
        spacing = 10
    }

    indicator:setup {
        layout = wibox.layout.stack,
        {
            widget = wibox.container.margin,
            margins = 8,
            notiflist,
        }
    }

    local timer_die = gears.timer { timeout = 6 }

    indicator.show = function(id, user, message)
        if timer_die.started then
            timer_die:again()
        else
            timer_die:start()
        end

        local text = user .. ": " .. message

        local textbox = {
            widget = wibox.widget.textbox,
            text = text
        }

        local reply = {
            widget = wibox.widget.textbox,
            id = "reply",
            text = ""
        }

        local reply_text = {
            widget = wibox.widget.textbox,
            text = "Reply",
            id = "reply_text",
            opacity = 0.7,
        }

        local replybox = wibox.widget {
            widget = wibox.layout.stack,
            reply_text,
            reply,
        }

        local keygrabber = awful.keygrabber({
            auto_start = true,
            stop_key = "Escape",
            stop_event = "release",
            keypressed_callback = function(self, mod, key, command)
                if key == "Escape" then
                    return
                elseif key == "Return" then
                    awful.spawn("python /home/satou/dc_dev/dcbus/client.py " .. id .. " " .. replybox:get_children_by_id("reply")[1].text)
                    replybox:get_children_by_id("reply")[1].text = ""
                elseif key == "BackSpace" then
                    if replybox:get_children_by_id("reply")[1].text ~= "" then
                        replybox:get_children_by_id("reply")[1].text = replybox:get_children_by_id("reply")[1].text:sub(1,-2)
                    end
                elseif has_value(exclude, key) then
                    return
                else
                    replybox:get_children_by_id("reply")[1].text = replybox:get_children_by_id("reply")[1].text .. key
                end

                if string.len(replybox:get_children_by_id("reply")[1].text) > 0 then
                    replybox:get_children_by_id("reply_text")[1].visible = false
                else
                    replybox:get_children_by_id("reply_text")[1].visible = true
                end
            end
        })

        indicator:connect_signal("mouse::enter", function()
            timer_die:stop()
        end)

        indicator:connect_signal("mouse::leave", function()
            timer_die:start()
            keygrabber:stop()
        end)

        local replyboxx = {
            widget = wibox.container.background,
            bg = beautiful.red,
            shape = helpers.rrect(6),
            clip_shape = helpers.rrect(10),
            replybox,
            buttons = {
                awful.button({}, 1, function()
                    keygrabber:start()
                end),
            },
        }

        local notifbox = {
            widget = wibox.container.background,
            forced_width = 300,
            forced_height = 120,
            bg = beautiful.blue,
            shape = helpers.rrect(8),
            {
                widget = wibox.container.margin,
                margins = 8,
                {
                    widget = wibox.layout.align.vertical,
                    spacing = 6,
                    textbox,
                    replyboxx,
                },
            },
        }

        notiflist:add(notifbox)

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
    
    return indicator
end
