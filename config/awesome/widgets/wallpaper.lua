local awful = require("awful")
local wibox = require("wibox")
local clickable_container = require("widgets.clickable-container")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

local widget = wibox.widget {
   {
      id = "icon",
      image = icon_dir .. "wally.png",
      widget = wibox.widget.imagebox,
      resize = true
   },
   layout = wibox.layout.align.horizontal
}

local widget_button = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7)))
widget_button:buttons(
   gears.table.join(
      awful.button({}, 0, nil,
         function()
            require("components.wallpaper").refresh()
         end
      ),
      awful.button({}, 1, nil,
         function()
            require("components.wallpaper").next()
         end
      ),
      awful.button({}, 2, nil,
         function()
            require("components.wallpaper").favorite()
         end
      )
   )
)

awful.tooltip(
   {
      objects = {widget_button},
      mode = "outside",
      align = "right",
      timer_function = function()
         return "Click to apply a random wallpaper | Refresh wallpapers"
      end,
      preferred_positions = {"right", "left", "top", "bottom"}
   }
)

return widget_button
