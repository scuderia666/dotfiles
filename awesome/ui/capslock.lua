local awful = require("awful")
local wibox = require("wibox")

local capslock = wibox.widget {
  widget = wibox.widget.textbox,
  align = "center",
  valign = "center",
  forced_width = 15,
}

capslock.activated = "<b>A</b>"
capslock.deactivated = "<b>a</b>"

local tooltip = awful.tooltip({})

tooltip:add_to_object(capslock)

function capslock:check()
  awful.spawn.with_line_callback(
    "bash -c 'sleep 0.2 && xset q'",
    {
      stdout = function (line)
        if line:match("Caps Lock") then
          local status = line:gsub(".*(Caps Lock:%s+)(%a+).*", "%2")
          tooltip.text = "Caps Lock " .. status
          if status == "on" then
            self.markup = self.activated
          else
            self.markup = self.deactivated
          end
        end
      end
    }
  )
end

capslock.key = awful.key(
  {},
  "Caps_Lock",
  function () capslock:check() end)

capslock:check()

return capslock
