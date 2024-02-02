local awful = require("awful")
local naughty = require("naughty")
local filesystem = require("gears.filesystem")
local run = require("util").run

require "setup":generate()

local config_dir = filesystem.get_configuration_dir()
launcher = "rofi -no-lazy-grab -show drun -modi drun -theme " .. config_dir .. "/ui/rofi.rasi"

brightness_temp = nil
--require("modules.brightness").get_brightness()

function focused_monitor_name()
    local screen = awful.screen.focused()

    local keys = {}

    for out,_ in pairs(screen.outputs) do
        table.insert(keys, out)
    end
    
    return keys[1]
end

require("theme")
require("ui")
require("rules")
require("keys")

local wall = require("modules.wall")

wall.refresh()
wall.set_wallpaper(wall.get_wallpaper("fractal.png"))

naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification {
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message
	}
end)

local function run(cmd)
    awful.spawn(cmd, false)
end

local function run_once(cmd, check)
if check == nil then
    check = cmd
end
awful.spawn.easy_async('pidof ' .. check, function(stdout, stderr, exitreason, exitcode)
    if exitcode ~= 0 then
        awful.spawn.with_shell(cmd)
    end
end)
end

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

run("setxkbmap tr")
run("xset r rate 300 30")
run("xsetroot -cursor_name left_ptr")
run("xrandr --output eDP-1 --primary --mode 1366x768 --pos 1680x282 --rotate normal --output DP-1 --mode 1680x1050 --pos 0x0 --rotate normal --output HDMI-1 --off")
--run("xrandr --output eDP-1 --gamma 0.7:0.7:0.6")
--run("xrandr --output DP-1 --gamma 0.5:0.5:0.5")
run("xgamma -gamma 0.9")

--run_once("/usr/libexec/polkit-gnome-authentication-agent-1")
run_once("lxpolkit")
run_once("dbus-run-session pipewire", "pipewire")
--run_once("picom --experimental-backends", "picom")