local awful = require("awful")
local filesystem = require("gears.filesystem")
local config_dir = filesystem.get_configuration_dir()

local mod = "Mod4"
local shift = "Shift"
local ctrl = "Control"
local alt = "Mod1"

awful.keyboard.append_global_keybindings({

	awful.key({ mod }, "Return", function()
		awful.spawn(terminal)
	end),
    
    awful.key({ mod }, "e", function()
		awful.spawn(file_manager)
	end),
    
    awful.key({ mod }, "b", function()
		awful.spawn(browser)
	end),
    
    awful.key({ mod }, "r", function()
		awful.spawn(launcher)
	end),
    
    awful.key({ mod }, "l", function()
        awesome.emit_signal("lockscreen::show")
    end)

})

awful.keyboard.append_global_keybindings({

    awful.key({}, "XF86MonBrightnessUp", function() 
        awful.spawn("brightnessctl set 10+ -q", false)
        awesome.emit_signal("update::brightness")
        awesome.emit_signal("hide_indicator::volume")
        awesome.emit_signal("show_indicator::brightness")
    end),

    awful.key({}, "XF86MonBrightnessDown", function()
        awful.spawn("brightnessctl set 10- -q", false)
        awesome.emit_signal("update::brightness")
        awesome.emit_signal("hide_indicator::volume")
        awesome.emit_signal("show_indicator::brightness")
    end),
    
    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn("amixer set Master 5%+", false)
        awesome.emit_signal("update::volume")
        awesome.emit_signal("hide_indicator::brightness")
        awesome.emit_signal("show_indicator::volume")
    end),
    
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn("amixer set Master 5%-", false)
        awesome.emit_signal("update::volume")
        awesome.emit_signal("hide_indicator::brightness")
        awesome.emit_signal("show_indicator::volume")
    end),
    
    awful.key({}, "F12", function()
        awful.spawn.easy_async_with_shell("maim -u ~/screenshots/$(date +%s).png")
    end),

    awful.key({shift}, "F12", function()
        awful.spawn.easy_async_with_shell("maim -s -u | xclip -selection clipboard -t image/png")
    end),

})

awful.keyboard.append_global_keybindings({
    awful.key({ mod, shift }, "r", awesome.restart),
})

awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { mod },
        keygroup    = "numrow",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers = { mod, "Shift" },
        keygroup    = "numrow",
        group       = "Tags",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
})

awful.keyboard.append_global_keybindings({
    awful.key({ mod }, "space", function() awful.layout.inc(1) end),
    awful.key({ mod, shift }, "space", function() awful.layout.inc(-1) end)
})

client.connect_signal("request::default_keybindings", function()
    awful.mouse.append_client_mousebindings({

        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),

        awful.button({ mod }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),

        awful.button({ mod }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),

    })

    awful.keyboard.append_client_keybindings({
        awful.key({ mod }, "f", function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end),

        awful.key({ mod }, "q", function (c)
            c:kill()
        end),

        awful.key({ mod }, "x", awful.client.floating.toggle),
    })
end)

awful.mouse.append_global_mousebindings({
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})