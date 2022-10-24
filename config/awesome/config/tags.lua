-- tags  / layouts
-- ~~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful     = require("awful")
local lmachi    = require("lib.layout-machi")
local bling     = require("lib.bling")
local beautiful = require("beautiful")

-- misc/vars
-- ~~~~~~~~~

-- bling layouts
local mstab     = bling.layout.mstab
local equal     = bling.layout.equalarea
local deck      = bling.layout.deck

-- layout machi
lmachi.editor.nested_layouts = {
    ["0"] = deck,
    ["1"] = awful.layout.suit.spiral,
    ["2"] = awful.layout.suit.fair,
    ["3"] = awful.layout.suit.fair.horizontal
}

-- names/numbers of layouts
local names = { "1", "2", "3", "4" }
local l     = awful.layout.suit


-- Configurations
-- **************

-- default tags
tag.connect_signal("request::default_layouts", function()

    awful.layout.append_default_layouts({
        l.floating, l.tile, lmachi.default_layout, equal, mstab, deck })

end)


-- set tags
screen.connect_signal("request::desktop_decoration", function(s)
    screen[s].padding = {left = 0, right = 0, top = 0, bottom = 0}
    awful.tag(names, s, awful.layout.layouts[1])
end)

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

client.connect_signal("property::selected", backham)
client.connect_signal("property::minimized", backham)
client.connect_signal("unmanage", backham)

tag.connect_signal(
  "property::selected",
  function (t)
    local selected = tostring(t.selected) == "false"
    if selected then
      local focus_timer = timer({ timeout = 0.1 })
      focus_timer:connect_signal("timeout", function()
        backham()
      end)
      focus_timer:start()
    end
  end
)