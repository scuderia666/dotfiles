local awful = require("awful")
local bling = require("lib.bling")
local apps = require("config.apps")

local modkey = "Mod4"

local shift = "Shift"
local ctrl  = "Control"
local alt = "Mod1"

--require("components.lockscreen").init()

awful.mouse.append_global_mousebindings({
    awful.button({ }, 1, function ()
      local tag = awful.screen.focused().selected_tag
      for _, c in pairs(tag:clients()) do
         if c.pid ~= quake_id then
            c.minimized = not c.minimized
         end
      end
   end),

    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})

awful.keyboard.append_global_keybindings({

	awful.key({ modkey }, "Return", function()
		awful.spawn(apps.term)
	end,
    { description = "open terminal", group = "launcher" }),
    
    awful.key({ modkey }, "e", function()
		awful.spawn(apps.fileman)
	end,
    { description = "open thunar", group = "launcher" }),
    
    awful.key({ modkey }, "r", function()
		awful.spawn(apps.launcher)
	end,
    { description = "open thunar", group = "launcher" }),
    
    awful.key({ modkey }, "l", function()
        --lock_screen_show()
        awful.spawn(apps.lock)
	end,
    { description = "show lockscreen", group = "launcher" }),
    
    awful.key({}, "F12", function ()
        awesome.emit_signal('module::quake_terminal:toggle')
    end
    ),
    
    awful.key({}, "F11", function ()
        awesome.emit_signal('module::buttons:toggle')
        end
    ),
    
})

awful.keyboard.append_global_keybindings({

    awful.key({}, "XF86AudioMute", function() 
        awful.spawn("amixer -D pulse set Master 1+ toggle", false) 
    end,
    {description = "mute volume", group = "control"}),
    
    awful.key({}, "XF86AudioLowerVolume", function ()
        awful.spawn.easy_async_with_shell("pactl set-sink-volume 0 -3%", function(stdout)
            awesome.emit_signal("popup::volume", {amount = -3})
        end)
    end),
    awful.key({}, "XF86AudioRaiseVolume", function ()
        awful.spawn.easy_async_with_shell("pactl set-sink-volume 0 +3%", function(stdout)
            awesome.emit_signal("popup::volume", {amount = 3})
        end)
    end),
    awful.key({}, "XF86AudioMute", function ()
        awful.spawn.easy_async_with_shell("pamixer -t", function(stdout)
            awesome.emit_signal("popup::volume")
        end)
    end),

    -- Brightness
   awful.key({ }, "XF86MonBrightnessDown", function ()
       awful.spawn.easy_async_with_shell("brightnessctl set 3%- > /dev/null", function(stdout)
           awesome.emit_signal("popup::brightness", {amount = -3})
       end)
   end),
   awful.key({ }, "XF86MonBrightnessUp", function ()
       awful.spawn.easy_async_with_shell("brightnessctl set +3% > /dev/null", function(stdout)
            awesome.emit_signal("popup::brightness", {amount = 3})
        end)
    end)

})



awful.keyboard.append_global_keybindings({

    awful.key({ modkey, shift }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    awful.key({ modkey, shift }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey }, "v", function () require("mods.exit-screen") awesome.emit_signal('module::exit_screen:show') end,
              {description = "show exit screen", group = "modules"}),
              
    awful.key({ alt,           }, "Tab",
      function ()
          apps.switcher.switch( 1, "Mod1", "Alt_L", "Shift", "Tab")
      end),
    
    awful.key({ alt, "Shift"   }, "Tab",
      function ()
          apps.switcher.switch(-1, "Mod1", "Alt_L", "Shift", "Tab")
      end),

})

awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tags"}),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "Left",
        function ()
            awful.client.focus.bydirection("left")
            bling.module.flash_focus.flashfocus(client.focus)
        end,
    {description = "focus left", group = "client"}),


    awful.key({ modkey }, "Right",
        function ()
            awful.client.focus.bydirection("right")
            bling.module.flash_focus.flashfocus(client.focus)
        end,
    {description = "focus right", group = "client"}),


    awful.key({ modkey }, "Tab",
        function ()
            awesome.emit_signal("bling::window_switcher::turn_on")
        end,
        {description = "window switcher", group = "client"}),

    awful.key({ modkey, ctrl }, "j", function () 
        awful.screen.focus_relative( 1) 
    end,
    {description = "focus the next screen", group = "screen"}),


    awful.key({ modkey, ctrl }, "k", function () 
        awful.screen.focus_relative(-1) 
    end,
    {description = "focus the previous screen", group = "screen"}),


    awful.key({ modkey, ctrl }, "n",
              function ()
                  local c = awful.client.restore()
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
    {description = "restore minimized", group = "client"}),
})

awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
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
        modifiers   = { modkey, ctrl },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },

    awful.key {
        modifiers = { modkey, shift },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },

    awful.key {
        modifiers   = { modkey, ctrl, shift },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },

    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({

        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),

        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),

        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),

    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey,           }, "c",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
        {description = "toggle fullscreen", group = "client"}),


        awful.key({ modkey }, "q",      function (c) c:kill() end,
                {description = "close", group = "client"}),

        awful.key({ modkey }, "x",  awful.client.floating.toggle,
                {description = "toggle floating", group = "client"}),


        awful.key({ modkey, ctrl }, "Return", function (c) c:swap(awful.client.getmaster()) end,
                {description = "move to master", group = "client"}),


        awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                {description = "move to screen", group = "client"}),


        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                {description = "toggle keep on top", group = "client"}),


        awful.key({ modkey,           }, "n",
            function (c)
                c.minimized = true
            end ,
        {description = "minimize", group = "client"}),


        awful.key({ modkey,           }, "z",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
        {description = "(un)maximize", group = "client"}),

    })

end)