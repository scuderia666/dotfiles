local awful = require("awful")
local filesystem = require("gears.filesystem")

local brightness = require("modules.brightness")
local volume = require("modules.volume")

local settings = require "setup".settings

local mod = "Mod4"
local shift = "Shift"
local ctrl = "Control"
local alt = "Mod1"

awful.mouse.snap.edge_enabled = false
awful.mouse.snap.client_enabled = false

local config_dir = filesystem.get_configuration_dir()
local scripts = config_dir .. "/stuff/scripts/"

awful.keyboard.append_global_keybindings({

	awful.key({ mod }, "Return", function()
		awful.spawn(settings.terminal)
	end),

    awful.key({ mod }, "e", function()
		awful.spawn(settings.file_manager)
	end),
    
    awful.key({ mod }, "b", function()
		awful.spawn(settings.browser)
	end),
    
    awful.key({ mod }, "r", function()
		awful.spawn("sh " .. scripts .. "launcher")
	end),
    
    awful.key({ mod }, "l", function()
        awesome.emit_signal("lockscreen::show")
    end),
    
    awful.key({ mod, shift }, "l", function()
        awesome.emit_signal("lockscreen::test")
    end)

})

awful.keyboard.append_global_keybindings({

    awful.key({}, "XF86MonBrightnessUp", function()
        brightness.brightness_up()
    end),

    awful.key({}, "XF86MonBrightnessDown", function()
        brightness.brightness_down()
    end),

    awful.key({}, "XF86AudioRaiseVolume", function()
        volume.volume_up()
    end),

    awful.key({}, "XF86AudioLowerVolume", function()
        volume.volume_down()
    end),
    
    awful.key({}, "Print", function()
        awful.util.spawn_with_shell("bash " .. scripts .. "monitorshot.sh")
    end),
    
    awful.key({ctrl}, "Print", function()
        awful.util.spawn_with_shell("bash " .. scripts .. "monitorshot.sh clipboard")
    end),
    
    awful.key({alt}, "Print", function()
        awful.util.spawn_with_shell("maim -s -u ~/screenshots/$(date +%s).png")
    end),

    awful.key({shift}, "Print", function()
        awful.util.spawn_with_shell("maim -s -u | xclip -selection clipboard -t image/png")
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
        --awful.key({ mod }, "x", awful.placement.centered),
        --awful.key({ mod }, "x", awful.placement.centered + awful.placement.no_offscreen),
    })
end)

local menu = require("ui.rightclick")

awful.mouse.append_global_mousebindings({
    awful.button({}, 3, function()
        menu.desktop:toggle()
        return
    end),
})

awful.keyboard.append_global_keybindings({
	awful.key({ mod }, "Tab", function()
		awful.client.focus.byidx(1)
		if client.focus then
			client.focus:raise()
		end
	end)
})
