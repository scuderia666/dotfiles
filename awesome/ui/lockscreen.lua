local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("modules.helpers")

awful.screen.connect_for_each_screen(function(s)
    local screen_width = s.geometry.width
    local screen_height = s.geometry.height

    local lockscreen = wibox({
        screen = s,
        width = screen_width,
        height = screen_height,
        bg = beautiful.red,
        ontop = true,
        visible = false
    })
    
    function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
            return count
    end

    function get_key_for_value(t, value)
        for k,v in pairs(t) do
            if v==value then return k end
        end
        return nil
    end

    local numbers = {
        ["I"] = 1,
        ["II"] = 2,
        ["III"] = 3,
        ["IV"] = 4,
        ["V"] = 5,
        ["VI"] = 6,
        ["VII"] = 7,
        ["VIII"] = 8,
        ["IX"] = 9,
    }

    local pass={}
    str="753268"
    str:gsub(".", function(c) table.insert(pass,c) end)

    local len = string.len(str)

    local characters_entered = 0
    local correct_count = 0

    local tries = 0

    local max_tries = 3
    local max_character = 8

    local promptbox = wibox.widget {
        widget = wibox.widget.textbox,
        font = "terminuss 40"
    }

    local type = function(number)
        if characters_entered == max_character then
            return
        end

        local needed = pass[correct_count + 1]

        if correct_count == characters_entered and tonumber(number) == tonumber(needed) then
            correct_count = correct_count + 1
        end

        characters_entered = characters_entered + 1
        
        promptbox.markup = helpers.colorizeText(string.rep("", characters_entered), beautiful.fg_color)
    end
    
    local reset = function()
        promptbox.markup = ""
        characters_entered = 0
        correct_count = 0
    end

    local check = function()
        if characters_entered == len then
            if correct_count == characters_entered then
                reset()

                tries = 0

                awesome.emit_signal("lockscreen::hide")
                
                return true
            end
        end

        return false
    end
    
    local send = function()
        if not check() then
            reset()

            tries = tries + 1

            if tries == max_tries then
                tries = 0

                awful.spawn("notify-send wrong")
            end
        end
    end

    local backspace = function()
        if characters_entered > 0 then
            if correct_count == characters_entered then
                correct_count = correct_count - 1
            end
                    
            characters_entered = characters_entered - 1

            promptbox.markup = helpers.colorizeText(string.rep("", characters_entered), beautiful.fg_color)
        end
    end

    local create_button = function(number)
        local widget = wibox.widget {
            widget = wibox.container.background,
            shape = helpers.rrect(20),
            {
                widget = wibox.widget.textbox,
                text = get_key_for_value(numbers, number),
                font = beautiful.icofont .. " 30",
                align = "center"
            },
        }

        widget:buttons {
            awful.button({}, 1, function()
                type(number)
                check(number)
            end)
        }

        helpers.add_hover(widget, beautiful.bg, beautiful.bg2)

        return widget
    end

    local backspace_widget = wibox.widget {
        widget = wibox.container.background,
        shape = helpers.rrect(20),
        {
            widget = wibox.widget.textbox,
            text = "<",
            font = beautiful.icofont .. " 30",
            align = "center"
        },

        buttons = {
            awful.button({}, 1, function()
                backspace()
            end)
        },
    }
    
    local send_widget = wibox.widget {
        widget = wibox.container.background,
        shape = helpers.rrect(20),
        {
            widget = wibox.widget.textbox,
            text = "⏎",
            font = beautiful.icofont .. " 30",
            align = "center"
        },

        buttons = {
            awful.button({}, 1, function()
                send()
            end)
        },
    }
    
    helpers.add_hover(backspace_widget, beautiful.bg, beautiful.bg2)
    helpers.add_hover(send_widget, beautiful.bg, beautiful.bg2)

    local buttons = wibox.layout {
        layout = wibox.layout.flex.vertical,
        spacing = 30,
        {
            layout = wibox.layout.flex.horizontal,
            spacing = 30,
            create_button(1),
            create_button(2),
            create_button(3)
        },
        {
            layout = wibox.layout.flex.horizontal,
            spacing = 30,
            create_button(4),
            create_button(5),
            create_button(6),
        },
        {
            layout = wibox.layout.flex.horizontal,
            spacing = 30,
            create_button(7),
            create_button(8),
            create_button(9)
        },
        {
            layout = wibox.layout.flex.horizontal,
            spacing = 30,
            send_widget,
            backspace_widget
        },
    }

    lockscreen:setup {
        layout = wibox.layout.stack,
        {
            widget = wibox.container.margin,
            margins = { right = 400, left = 400 },
            {
                layout = wibox.layout.align.vertical,
                spacing = 20,
                {
                    widget = wibox.container.margin,
                    margins = { top = 80 },
                    {
                        widget = wibox.container.background,
                        bg = beautiful.blue,
                        promptbox
                    },
                },
                {
                    widget = wibox.container.margin,
                    margins = { top = 300 },
                    {
                        widget = wibox.container.background,
                        bg = beautiful.blue,
                        {
                            widget = wibox.container.margin,
                            margins = 20,
                            buttons
                        },
                    },
                },
            },
        },
    }

    local password_grabber = awful.keygrabber {
        auto_start = true,
		stop_event = "release",
		mask_event_callback = true,
        keypressed_callback = function(self, mod, key, command) 
            if #key == 1 then
                type(key)
            elseif key == "Return" then
                send()
            elseif key == "BackSpace" then
                backspace()
            elseif key == "Escape" then
				reset()
			end
        end,

        keyreleased_callback = function(self, mod, key, command)
            check()
        end
    }

    awesome.connect_signal("lockscreen::hide", function()
        lockscreen.visible = false
        password_grabber:stop()
    end)

    awesome.connect_signal("lockscreen::show", function()
        lockscreen.visible = true
        password_grabber:start()
    end)
end)
