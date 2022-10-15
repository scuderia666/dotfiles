--       █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗
--      ██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝
--      ███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗
--      ██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝
--      ██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗
--      ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝


-- Standard awesome libraries
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

dir = gears.filesystem.get_configuration_dir()

function tablelength(T)
   local count = 0
   for _ in pairs(T) do count = count + 1 end
   return count
end

current=1

themes = {
   "miku"
}
theme = themes[current]
theme_count = tablelength(themes)

themes_dir = dir .. "themes/"

theme_dir = themes_dir .. theme
config_dir = theme_dir .. "/configuration/"
config = require("config")

theme_config = require("themes." .. theme .. ".config")
icon_dir = theme_dir .. "/icons/"
components_dir = "themes." .. theme .. ".components."
widgets_dir = "themes." .. theme .. ".widgets."

function nexttheme()
    local index={}
    for k,v in pairs(themes) do
       index[v]=k
    end
    local val = index[theme]
    if current == theme_count then
        return
    end
    awful.spawn.easy_async_with_shell(dir .. "next-theme.sh " .. current .. " " .. theme_count, false)
    awesome.restart()
end

-- ===================================================================
-- Initialization
-- ===================================================================

require("components.quake-terminal")
require("components.wallpaper").init()
--require("components.flash_focus").enable()

local theme = require("themes." .. theme)

-- Import theme
beautiful.init(theme.theme)
theme.initialize()

-- Import Keybinds
local keys = require("keys")
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

-- Import rules
local create_rules = require("rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

-- Define layouts
awful.layout.layouts = {
   awful.layout.suit.tile,
   awful.layout.suit.floating,
   awful.layout.suit.max,
}

-- remove gaps if layout is set to max
tag.connect_signal('property::layout', function(t)
   local current_layout = awful.tag.getproperty(t, 'layout')
   if (current_layout == awful.layout.suit.max) then
      t.gap = 0
   else
      t.gap = beautiful.useless_gap
   end
end)

function backham()
    local s = awful.screen.focused()
    local c = awful.client.focus.history.get(s, 0)
    if c then
        client.focus = c
        c:raise()
    end
end

client.connect_signal("property::minimized", backham)
client.connect_signal("unmanage", backham)

tag.connect_signal(
  "property::selected",
  function (t)
    local selected = tostring(t.selected) == "false"
    if selected then
      local focus_timer = timer({ timeout = 0.1 })
      focus_timer:connect_signal("timeout", function()
        local c = awful.mouse.client_under_pointer()
        if not (c == nil) then
          client.focus = c
          c:raise()
        end
        focus_timer:stop()
      end)
      focus_timer:start()
    end
  end
)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
   -- Set the window as a slave (put it at the end of others instead of setting it as master)
   if not awesome.startup then
      awful.client.setslave(c)
   end

   if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
   end
end)

-- ===================================================================
-- Screen Change Functions (ie multi monitor)
-- ===================================================================


-- Reload config when screen geometry changes
screen.connect_signal("property::geometry", awesome.restart)


-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================


collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

awful.spawn("bash " .. dir .. "/autostart.sh " .. config_dir)