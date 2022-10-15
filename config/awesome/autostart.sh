#!/bin/sh

exe() {
    local cmd=$@
    if ! pgrep -x $cmd; then
        $cmd &
    fi
}

exe picom --experimental-backends --config $1/picom.conf
exe setxkbmap tr
exe xset r rate 300 30
exe lxpolkit
exe nm-applet
#exe xrandr --output LVDS1 --gamma 0.9
#exe redshift -x && redshift -O 3700
#exe brightnessctl s 70