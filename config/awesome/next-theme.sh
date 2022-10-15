#/bin/sh
var="current=$1"
var2="current=$((current+1))"
sed -i "s/$var/$var2/g" $HOME/.config/awesome/rc.lua