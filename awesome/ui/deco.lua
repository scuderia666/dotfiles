------------------------
-- Client Decorations --
------------------------

-- Imports
----------
local awful     = require('awful')
local wibox     = require('wibox')
local gears     = require('gears')
local beautiful = require('beautiful')
local dpi       = beautiful.xresources.apply_dpi

local helpers   = require('modules.helpers')

local title_size = 24

-- Buttons
----------
local mkbutton = function (width, color, onclick)
  return function(c)
    local button = wibox.widget {
      wibox.widget.textbox(),
      forced_width  = dpi(width),
      forced_height = dpi(title_size),
      bg            = color,
      shape         = helpers.rrect(beautiful.rounded * 0.5),
      widget        = wibox.container.background
    }

    local color_transition = helpers.apply_transition {
      element   = button,
      prop      = 'bg',
      bg        = color,
      hbg       = beautiful.blk,
    }

    client.connect_signal("property::active", function ()
      if c.active then
        color_transition.off()
      else
        color_transition.on()
      end
    end)

    button:add_button(awful.button({}, 1, function ()
      if onclick then
        onclick(c)
      end
    end))

    return button
  end
end

local close = mkbutton(title_size * 4/3, beautiful.red, function(c)
    c:kill()
end)

local maximize = mkbutton(title_size * 3/4, beautiful.ylw, function(c)
    c.maximized = not c.maximized
end)

local sticky = mkbutton(title_size * 3/4, beautiful.grn, function(c)
    c.sticky = not c.sticky
end)

-- Titlebars
------------
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)

    if c.requests_no_titlebar then
        return
    end
    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }

    local n_titlebar = awful.titlebar(c, {
            size        = title_size,
            position    = "top",
        })
    n_titlebar.widget = {
        {
            { -- Left
                {
                  close(c),
                  direction = "north",
                  widget    = wibox.container.rotate
                },
                {
                  maximize(c),
                  direction = "north",
                  widget    = wibox.container.rotate
                },
                {
                  sticky(c),
                  direction = "north",
                  widget    = wibox.container.rotate
                },
                spacing = dpi(title_size / 4),
                layout  = wibox.layout.fixed.horizontal
            },
            { -- Middle
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },
            { -- Right
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },
            spacing = dpi(title_size / 4),
            layout  = wibox.layout.align.horizontal
        },
        top     = dpi(title_size / 3),
        bottom  = dpi(title_size / 3),
        left    = dpi(title_size / 3),
        right   = dpi(title_size / 2),
        widget  = wibox.container.margin
    }
end)