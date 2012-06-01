#!/bin/zsh
#Map Capslock to ESC
setxkbmap -option caps:escape &
#Wallpaper
feh --bg-scale /mnt/data/Dropbox/pic/PG_1366x768.jpg
#turn off beep sound
xset -b
#mouse speed
xset m 1/5
#keyboard repeat
xset r rate 200 30
#font
xset +fp /usr/share/fonts/local
xset fp rehash
#urxvtd daemon
urxvtd -q -f -o &
#Disable touchpad tapping and scrolling when typing
syndaemon -t -i 2 &
# Dropbox
(sleep 300 && dropboxd) &
#dwm status
while true
do
  xsetroot -name "nXqd"
	sleep 20s
done &
#change keyboard
#if [ -f $HOME/.Xmodmap ]; then
#  /usr/bin/xmodmap $HOME/.Xmodmap
#fi
#WM
exec dwm
