local awful = require("awful")

awful.screen.connect_for_each_screen(function(s)
    require("ui.indicator.volume_indicator")(s)
    require("ui.indicator.brightness_indicator")(s)
end)