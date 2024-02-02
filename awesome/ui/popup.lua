local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("modules.helpers")
local dpi = beautiful.xresources.apply_dpi
local hover = require("util").hover

local settings = require "setup".settings

local prompt, popup
local execute = ""

local make_button = function(image, func)
    local button = wibox.widget {
        widget = wibox.container.background,
        shape = helpers.rrect(16),
        forced_width = 50,
        forced_height = 50,
        bg = beautiful.bg_3,
        {
            widget = wibox.container.place,
            {
                widget = wibox.widget.imagebox,
                image = beautiful.images .. "/" .. image,
            },
        },
        buttons = {
            awful.button({}, 1, function()
                execute = func
                popup.visible = false
                prompt.visible = true
            end)
        }
    }

    helpers.add_hover(button, beautiful.lbg, beautiful.blk)

    return button
end

awful.screen.connect_for_each_screen(function(s)
    local screen_width = s.geometry.width
    local screen_height = s.geometry.height
    
    local width = 80
    local height = 200

    popup = wibox({
        shape = helpers.rrect(16),
        screen = s,
        width = width,
        height = height,
        x = screen_width - width,
        y = screen_height/3,
        bg = beautiful.lbg,
        ontop = true,
        visible = false,
    })
    
    prompt = wibox({
        shape = helpers.rrect(16),
        screen = s,
        width = width,
        height = height,
        x = screen_width - width,
        y = screen_height/3,
        bg = beautiful.bg,
        ontop = true,
        visible = false,
    })

    local poweroff = make_button("power.svg", settings.poweroff_cmd)
    local restart = make_button("restart.svg", settings.reboot_cmd)
    local logout = make_button("logout.png", "awesome-client 'awesome.quit()'")

    popup:setup {
        widget = wibox.container.margin,
        margins = dpi(14),
        {
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(12),
            poweroff,
            restart,
            logout,
        },
    }
    
    popup:connect_signal("property::visible", function()
        local _key_grabber
        if popup.visible then
            _key_grabber = awful.keygrabber.run(function(mod, key, event)
                popup.visible = false
                awful.keygrabber.stop(_key_grabber)
            end)
        end
    end)

    prompt:connect_signal("property::visible", function()
        local _key_grabber
        if popup.visible then
            _key_grabber = awful.keygrabber.run(function(mod, key, event)
                popup.visible = false
                awful.keygrabber.stop(_key_grabber)
            end)
        end
    end)

    local yes = wibox.widget {
        widget = wibox.container.background,
        {
            widget = wibox.widget.imagebox,
            image = beautiful.images .. "/plus.svg"
        },

        buttons = {
            awful.button({}, 1, function()
                awful.spawn(execute)
                prompt.visible = false
            end)
        }
    }
    
    local no = wibox.widget {
        widget = wibox.container.background,
        {
            widget = wibox.widget.imagebox,
            image = beautiful.images .. "/close.svg"
        },
        buttons = {
            awful.button({}, 1, function()
                prompt.visible = false
            end)
        }
    }
    
    helpers.add_hover(yes, beautiful.lbg, beautiful.blk)
    helpers.add_hover(no, beautiful.lbg, beautiful.blk)

    prompt:setup {
        layout = wibox.layout.flex.vertical,
        yes,
        no,
    }
end)

awesome.connect_signal("popup::show", function()
    popup.visible = true
end)
