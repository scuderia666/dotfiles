rofi_cmd = "rofi -normal-window -modi drun -show drun -theme " .. config_dir .. "rofi/"

apps = {
    term = "urxvt",
    lock = "i3lock",
    switcher = require("widgets.alt-tab"),
    ss = "scrot -e 'mv $f ~/Pictures/ 2>/dev/null'",
    ss_sel = "maim -s -u | xclip -selection clipboard -t image/png -i",
    fileman = "thunar",
    launcher = rofi_cmd .. "center.rasi",
}

return apps