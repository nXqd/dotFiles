#!/bin/zsh

#turn off beep sound
xset -b

#mouse speed
#xset m 1/5

#font
xset +fp /usr/share/fonts/local
xset fp rehash


#WM
exec dwm
