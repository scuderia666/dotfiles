#!/bin/bash

STEP=10

get_brightness() {
    Brightness=$(xrandr --verbose --current | grep ^"$1" -A5 | tail -n1)
    number=${Brightness##* }
    value=${number#*.}
    if [[ "$value" == "0" ]]; then
        echo "100"
    else
        echo $value
    fi
}

change_brightness() {
    current=$(get_brightness $2)
    result=$current

    value=$1

    re='^[0-9]+$'

    if [[ "$value" == "+" ]]; then
        if [[ "$current" == "100" ]]; then
            return
        fi

        result=$((current + STEP))
    elif [[ "$value" == "-" ]]; then
        if [[ "$current" == "10" ]]; then
            return
        fi

        result=$((current - STEP))
    elif [[ $value =~ $re ]]; then
        if (( $value > 100 )); then
            value=100
        elif (( $value < 10 )); then
            value=10
        else
            result=$value
        fi
    else
        return
    fi

    if [[ "$result" == "100" ]]; then
        result=1
    else
        result="0.$result"
    fi

    xrandr --output "$2" --brightness "$result"
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
