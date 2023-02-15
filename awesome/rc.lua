local filesystem = require("gears.filesystem")
local run = require("util").run

local config_dir = filesystem.get_configuration_dir()

terminal = "tym"
browser = "firefox"
file_manager = "thunar"

launcher = "rofi -no-lazy-grab -show drun -modi drun -theme " .. config_dir .. "/ui/rofi.rasi"

poweroff_cmd = "doas poweroff"
reboot_cmd = "doas reboot"

require("theme")
require("ui")
require("rules")
require("keys")

require("modules.wall")

awesome.emit_signal("wallpaper::refresh")
awesome.emit_signal("wallpaper::rand")

run.run_once_pgrep("setxkbmap tr")
run.run_once_pgrep("xset r rate 300 30")
run.run_once_pgrep("xrandr --output LVDS1 --gamma 0.7:0.7:0.6")
run.run_once_ps(
    "lxpolkit",
    "polkit-gnome-authentication-agent-1",
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
)
run.run_once_pgrep("nm-applet")
run.run_once_pgrep("pipewire")