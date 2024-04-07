local awful = require("awful")
local gears = require("gears")
local filesystem = require("gears.filesystem")

local config_dir = filesystem.get_configuration_dir()

local function run(cmd)
    awful.spawn(cmd, false)
end

local function run_once(cmd, check)
    if check == nil then
        check = cmd
    end

    awful.spawn.easy_async('pidof ' .. check, function(stdout, stderr, exitreason, exitcode)
        if exitcode ~= 0 then
            awful.spawn(cmd, false)
        end
    end)
end

run("setxkbmap tr")
run("xset r rate 300 50")

run_once("nm-applet")
run_once("parcellite")
run_once("/usr/libexec/polkit-gnome-authentication-agent-1")

awful.spawn.once("pipewire")
awful.spawn.once("picom --config " .. config_dir .. "/stuff/picom.conf")
awful.spawn.once("vibrant-cli eDP-1-1 1.8")
