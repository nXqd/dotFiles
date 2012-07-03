#!/bin/zsh
#Map Capslock to ESC
setxkbmap -option caps:escape &
#Wallpaper
feh --bg-scale /mnt/data/Dropbox/pic/character/samurai.png
#turn off beep sound
xset -b
#mouse speed
xset m 1/5
#keyboard repeat speed
xset r rate 200 30
#font
xset +fp /usr/share/fonts/local
xset fp rehash
#urxvtd daemon
urxvtd -q -f -o &
#Disable touchpad tapping and scrolling when typing
syndaemon -t -i 2 &
#Hide cursor
unclutter -keystroke &
#Redshift - change your screen temp to reduce eyestrain
redshift -c ~/.redshift.conf &
# Dropbox
dropboxd &
#dwm status
while true
do
  xsetroot -name "nXqd"
	sleep 20s
done &
#Window manager
exec dwm
