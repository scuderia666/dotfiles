#!/bin/bash

STEP=10

get_brightness() {
    Brightness=$(xrandr --verbose --current | grep ^"$1" -A5 | tail -n1)
    echo ${Brightness##* }
}

change_brightness() {
    CurrBright=$(get_brightness $2)

    Left=${CurrBright%%"."*}
    Right=${CurrBright#*"."}

    MathBright="0"
    [[ "$Left" != 0 ]] && MathBright="$Left"00
    [[ "${#Right}" -eq 1 ]] && Right="$Right"0
    MathBright=$(( MathBright + Right ))
    [[ "$Right" == 050 ]] && MathBright=5
    [[ "$CurrBright" == 0.0 ]] && MathBright=5

    [[ "$1" == "Up" || "$1" == "+" ]] && MathBright=$(( MathBright + STEP ))
    [[ "$1" == "Down" || "$1" == "-" ]] && MathBright=$(( MathBright - STEP ))
    [[ "$MathBright" -gt 100  ]] && MathBright=100

    if [[ "${#MathBright}" -eq 3 ]] ; then
        MathBright="$MathBright"000
        CurrBright="${MathBright:0:1}.${MathBright:1:2}"
    else
        MathBright="$MathBright"000
        CurrBright=".${MathBright:0:2}"
        [[ "$MathBright" == 5000 ]] && CurrBright=.05
    fi

    xrandr --output "$2" --brightness "$CurrBright"
}

if [[ "$1" == "get" ]]; then
    if [[ -z $2 ]]; then
        echo "no monitor given"
        exit 1
    fi
    echo $(get_brightness $2)
    exit 0
fi

if [[ -z "$2" ]]; then
    MONITORS=$(xrandr --listactivemonitors | tail -n +2 | awk '{print $NF}')
    
    for each in $MONITORS; do change_brightness $1 $each; done
else
    change_brightness $1 $2
fi