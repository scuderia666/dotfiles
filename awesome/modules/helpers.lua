local helpers   = {}
local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
local dpi       = beautiful.xresources.apply_dpi

local color     = require('modules.color')
local rubato    = require('modules.rubato')

helpers.rrect = function(radius)
  radius = radius or dpi(4)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end
end

helpers.prect = function(tl, tr, br, bl, radius)
  radius = radius or dpi(4)
  return function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
  end
end
helpers.clickKey = function(c, key)
  awful.spawn.with_shell("xdotool type --window " .. tostring(c.window) .. " '" .. key .. "'")
end

helpers.colorizeText = function(txt, fg)
  if fg == "" then
    fg = "#ffffff"
  end

  return "<span foreground='" .. fg .. "'>" .. txt .. "</span>"
end

function helpers.apply_transition(opts)
    opts = opts or {}
    local bg      = opts.bg  or beautiful.lbg
    local hbg     = opts.hbg or beautiful.blk
    local element = opts.element
    local prop    = opts.prop
    local background       = color.color { hex = bg }
    local hover_background = color.color { hex = hbg }
    local transition       = color.transition(background, hover_background, color.transition.RGB)
    local fading = rubato.timed {
        duration = 0.30,
    }
    fading:subscribe(function(pos)
        element[prop] = transition(pos / 100).hex
    end)
    return {
        on  = function()
            fading.target = 100
        end,
        off = function()
            fading.target = 0
        end
    }
end

function helpers.add_hover(element, bg, hbg)
    local transition = helpers.apply_transition {
        element = element,
        prop    = 'bg',
        bg      = bg,
        hbg     = hbg,
    }
    element:connect_signal('mouse::enter', transition.on)
    element:connect_signal('mouse::leave', transition.off)
end

function helpers.tableMerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                tableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

return helpers
