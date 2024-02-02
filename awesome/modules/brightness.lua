local awful = require("awful")
local filesystem = require("gears.filesystem")

local script = filesystem.get_configuration_dir() .. "/scripts/brightness.sh"

local brightness = {}

brightness.get_monitor = function(monitor)
    if monitor ~= nil then
        return monitor
    else
        return focused_monitor_name()
    end
end

brightness.get_brightness = function(monitor)
    awful.spawn.easy_async_with_shell(
        "bash " .. script .. " get " .. brightness.get_monitor(monitor),
        function(stdout)
            brightness_temp = stdout
        end
    )

    return brightness_temp
end

brightness.brightness_up = function(monitor)
    awful.spawn("bash " .. script .. " + " .. brightness.get_monitor(monitor), false)

    --awesome.emit_signal("update::brightness")
end

brightness.brightness_down = function(monitor)
    awful.spawn("bash " .. script .. " - " .. brightness.get_monitor(monitor), false)

    --awesome.emit_signal("update::brightness")
end

brightness.set_brightness = function(value, monitor)
    awful.spawn("bash " .. script .. " " .. value .. " " .. brightness.get_monitor(monitor), false)

    --awesome.emit_signal("update::brightness")
end

brightness.show_indicator = function()
    awesome.emit_signal("hide_indicator::volume")
    awesome.emit_signal("show_indicator::brightness")
end

return brightness