local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local cairo = require("lgi").cairo

awful.screen.connect_for_each_screen(function(s)
    local screen_width = s.geometry.width
    local screen_height = s.geometry.height
    
    local manual = wibox.layout {
        layout = wibox.layout.manual
    }
    
    local box = wibox.widget {
      widget = wibox.container.background,
      bg = gears.color('#0ffff088'),
      border_color = beautiful.red,
      border_width = 4,
      forced_width = 0,
      forced_height = 0,
      x = 300,
      y = 300,
      visible = true,
    }

    local desktopdisplay = wibox {
        visible = true,
        ontop = false,
        bg = beautiful.bg .. "00",
        screen = s,
        width = screen_width,
        height = screen_height,
        widget = wibox.widget {
            layout = wibox.layout.stack,
            manual
        },
    }

    local rect = wibox.widget {
        fit = function(self, context, width, height)
            return height, height
        end,
        draw = function(self, context, cr, width, height)
            cr:set_source_rgb(1, 0, 0)
            cr:rectangle(400, 100, 40, 40)
            cr:fill()
        end,
        forced_width = 30,
        forced_height = 30,
        layout = wibox.widget.base.make_widget,
    }
    
    box.point = { x = 300, y = 300 }

    manual:add(box)

    box.forced_width = 300
    box.forced_height = 300
    
    local stuff = function()
        if true then
                mousegrabber.run(function(m)
                 awful.spawn("notify-send hi")
                 local box = wibox.widget {
      widget = wibox.container.background,
      bg = gears.color('#0ffff088'),
      border_color = beautiful.red,
      border_width = 4,
      forced_width = 0,
      forced_height = 0,
      x = 300,
      y = 300,
      visible = true,
    }
                    box.x = m.x
                    box.y = m.y
                    box.point.x = m.x
                    box.point.y = m.y
                    manual:reset()
                    manual:add(box)
                    
                    if not m.buttons[1] then
                        mousegrabber.stop()
                    end
                end, "test")
            end
    end
    
    manual:connect_signal("button::press", function(_, _, _, button)
    stuff()
    end)

    manual:buttons {
        awful.button({}, 1, function()
        --stuff()
            --[[box.x = mouse.coords().x
            box.y = mouse.coords().y
            box.point.x = mouse.coords().x
            box.point.y = mouse.coords().y
            manual:reset()
            manual:add(box)]]--
            
        end)
    }
end)
