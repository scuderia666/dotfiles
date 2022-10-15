local awful = require("awful")
local gears = require("gears")

local miku = {}

miku.initialize = function()
   -- Import components
   require("components.exit-screen")

   -- Set up each screen (add tags & panels)
   awful.screen.connect_for_each_screen(function(s)
      for i = 1, 4, 1
      do
         awful.tag.add(i, {
            icon = gears.filesystem.get_configuration_dir() .. "/icons/tags/miku/" .. i .. ".png",
            icon_only = true,
            layout = awful.layout.suit.tile,
            screen = s,
            selected = i == 1
         })
      end

      require(components_dir .. "top-panel").create(s)
   end)
end

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local theme = {}

theme.name = "miku"

-- Font
theme.font = "Terminus Bold"
theme.title_font = "SF Pro Display Medium 10"

-- Background
theme.bg_normal = "#1f2430"
theme.bg_dark = "#000000"
theme.bg_focus = "#151821"
theme.bg_urgent = "#ed8274"
theme.bg_minimize = "#444444"

-- Foreground
theme.fg_normal = "#ffffff"
theme.fg_focus = "#e4e4e4"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

-- Window Gap Distance
theme.useless_gap = dpi(9)

-- Show Gaps if Only One Client is Visible
theme.gap_single_client = true

-- Window Borders
theme.border_width = dpi(0)
theme.border_normal = theme.bg_normal
theme.border_focus = "#ff8a65"
theme.border_marked = theme.fg_urgent

-- Taglist
theme.taglist_bg_empty = theme.bg_normal
theme.taglist_bg_occupied = "#ffffff1a"
theme.taglist_bg_urgent = "#e91e6399"
theme.taglist_bg_focus = theme.bg_focus

-- Tasklist
theme.tasklist_font = theme.font

theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_bg_urgent = theme.bg_urgent

theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_fg_urgent = theme.fg_urgent
theme.tasklist_fg_normal = theme.fg_normal

-- Panel Sizing
theme.left_panel_width = dpi(55)
theme.top_panel_height = dpi(26)

-- Notification Sizing
theme.notification_max_width = dpi(350)

-- System Tray
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = dpi(5)

-- Titlebars
theme.titlebars_enabled = true

theme.flash_focus_start_opacity = 0.6 -- the starting opacity
theme.flash_focus_step = 0.01

-- ===================================================================
-- Icons
-- ===================================================================


-- Define layout icons
theme.layout_tile = icon_dir .. "layouts/tiled.png"
theme.layout_floating = icon_dir .. "layouts/floating.png"
theme.layout_max = icon_dir .. "layouts/maximized.png"

theme.icon_theme = "Tela-dark"

miku.theme = theme

return miku
