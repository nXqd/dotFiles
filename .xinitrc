#!/bin/zsh

#turn off beep sound
xset -b

#mouse speed
xset m 1/5

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

#WM
exec dwm
