local awful = require("awful")

local volume = {}

volume_temp = 0

volume.show_indicator = function()
    awesome.emit_signal("hide_indicator::brightness")
    awesome.emit_signal("show_indicator::volume")
end

volume.volume_up = function(update)
    awful.spawn("amixer set Master 5%+", false)

    if update ~= false then
        awesome.emit_signal("update::volume")
    end

    volume.show_indicator()
end

volume.volume_down = function(update)
    awful.spawn("amixer set Master 5%-", false)

    if update ~= false then
        awesome.emit_signal("update::volume")
    end
    
    volume.show_indicator()
end

volume.set_volume = function(value, update)
    awful.spawn("amixer set Master " .. value .. "%", false)

    if update ~= false then
        awesome.emit_signal("update::volume")
    end
end

volume.get_volume = function()
    awful.spawn.easy_async_with_shell("bash -c 'pamixer --get-volume'", function(stdout)
        volume_temp = tonumber(stdout)
    end)

    return volume_temp
end

return volume
