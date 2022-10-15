local gears = require("gears")
local filesystem = require("gears.filesystem")

local config = {}

config.modkey = "Mod4"
config.altkey = "Mod1"

rofi_cmd = "rofi -normal-window -modi drun -show drun -theme " .. config_dir .. "rofi/"

config.apps = {
    terminal = "kitty",
    launcher_center = rofi_cmd .. "center.rasi",
    launcher_medium_center = rofi_cmd .. "medium_center.rasi",
    launcher_big_center = rofi_cmd .. "big_center.rasi",
    launcher_huge_center = rofi_cmd .. "huge_center.rasi",
    lock = "i3lock",
    screenshot = "scrot -e 'mv $f ~/Pictures/ 2>/dev/null'",
    screenshot_seldraw = "maim -s -u | xclip -selection clipboard -t image/png -i",
    filebrowser = "thunar"
}

config.network_interfaces = {
    wlan = 'wlp1s0',
    lan = 'enp1s0'
}

return config
