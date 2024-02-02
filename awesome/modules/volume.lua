local awful = require("awful")

local volume = {}

volume.show_indicator = function()
    awesome.emit_signal("hide_indicator::brightness")
    awesome.emit_signal("show_indicator::volume")
end

volume.volume_up = function()
    awful.spawn("amixer set Master 5%+", false)

    awesome.emit_signal("update::volume")
    
    volume.show_indicator()
end

volume.volume_down = function()
    awful.spawn("amixer set Master 5%-", false)

    awesome.emit_signal("update::volume")
    
    volume.show_indicator()
end

volume.set_volume = function(value)
    awful.spawn("amixer set Master " .. value .. "%", false)
end

return volume