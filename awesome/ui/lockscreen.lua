local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local helpers = require("modules.helpers")
local rubato = require("modules.rubato")

local blur_background = false
local tmp_dir = "/tmp/awesomewm/"

local filter_bg_image = function(wall_name, ap, width, height)
	local blur_filter_param = ''
	if blur_background then
		blur_filter_param = '-filter Gaussian -blur 0x10'
	end

	local magic = [[
	sh -c "
	if [ ! -d ]] .. tmp_dir ..[[ ];
	then
		mkdir -p ]] .. tmp_dir .. [[;
	fi
	convert -quality 100 -brightness-contrast -20x0 ]] .. ' '  .. blur_filter_param .. ' '.. beautiful.images .. "/" .. wall_name .. 
	[[ -gravity center -crop ]] .. ap .. [[:1 +repage -resize ]] .. width .. 'x' .. height .. 
	[[! ]] .. tmp_dir .. wall_name .. [[
	"]]
	return magic
end

awful.screen.connect_for_each_screen(function(s)
    local screen_width = s.geometry.width
    local screen_height = s.geometry.height

    local aspect_ratio = screen_width / screen_height
    aspect_ratio = math.floor(aspect_ratio * 100) / 100

    --local cmd = nil
    --cmd = filter_bg_image("lockscreen.png", aspect_ratio, screen_width, screen_height)

    local lockscreen = wibox({
        screen = s,
        width = screen_width,
        height = screen_height,
        ontop = true,
        visible = false,
        bgimage = beautiful.images .. "/lockscreen.png"
    })

    --[[awful.spawn.easy_async_with_shell(
        cmd,
        function()
            lockscreen.bgimage = tmp_dir .. "lockscreen.png"
        end
    )]]--

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
    str="xdrefc"
    str:gsub(".", function(c) table.insert(pass,c) end)

    local len = string.len(str)

    local characters_entered = 0
    local correct_count = 0

    local tries = 0

    local max_tries = 3
    local max_character = 10

    local promptbox = wibox.widget {
        widget = wibox.widget.textbox,
        font = "Cantarell 40",
        align = "center",
    }

    local type = function(key)
        if characters_entered == max_character then
            return
        end

        local needed = pass[correct_count + 1]

        if correct_count == characters_entered and key == needed then
            correct_count = correct_count + 1
        end

        characters_entered = characters_entered + 1
        
        promptbox.markup = helpers.colorizeText(string.rep("*", characters_entered), beautiful.fg)
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
        if characters_entered == 0 then
            return
        end

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

            promptbox.markup = helpers.colorizeText(string.rep("*", characters_entered), beautiful.fg)
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

        local transition = helpers.apply_transition {
            element = widget,
            prop    = 'bg',
            bg      = beautiful.bg,
            hbg     = beautiful.accent,
            duration = 0.15,
        }

        local timed = rubato.timed {
            duration = 0.25,
        }

        timed:subscribe(function(pos)
            widget.shape = helpers.rrect(28 - pos)
        end)

        widget:connect_signal("button::press", function()
            timed.target = 20
        end)

        widget:connect_signal("button::release", function()
            type(number)
            check(number)
        end)

        widget:connect_signal("mouse::enter", function()
            transition.on()
        end)

        widget:connect_signal("mouse::leave", function()
            transition.off()
            timed.target = 8
        end)

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
        spacing = 25,
        {
            layout = wibox.layout.flex.horizontal,
            spacing = 20,
            create_button(1),
            create_button(2),
            create_button(3)
        },
        {
            layout = wibox.layout.flex.horizontal,
            spacing = 20,
            create_button(4),
            create_button(5),
            create_button(6),
        },
        {
            layout = wibox.layout.flex.horizontal,
            spacing = 20,
            create_button(7),
            create_button(8),
            create_button(9)
        },
        {
            layout = wibox.layout.flex.horizontal,
            spacing = 20,
            send_widget,
            backspace_widget
        },
    }
    
    local clock_format = '<span font="Inter Bold 52">%H:%M</span>'

    local time = wibox.widget.textclock(clock_format, 1)
    
    local test_bg = function(color)
        return wibox.widget {
            widget = wibox.widget.background,
            bg = color
        }
    end
    
    lockscreen:setup {
        layout = wibox.layout.stack,
        {
            widget = wibox.container.margin,
            margins = { right = 400, left = 400 },
            {
                layout = wibox.layout.flex.vertical,
                {
                    widget = wibox.container.margin,
                    margins = 80,
                    {
                        widget = wibox.container.place,
                        time
                    },
                },
                {
                    layout = wibox.layout.align.vertical,
                    expand = "none",
                    spacing = 20,
                    {
                        widget = wibox.container.background,
                        shape = helpers.rrect(32),
                        bg = beautiful.bg3,
                        opacity = 0.6,
                        promptbox,
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

    awesome.connect_signal("lockscreen::test", function()
        lockscreen.visible = not lockscreen.visible
        reset()
        type("a")
        type("b")
    end)
end)