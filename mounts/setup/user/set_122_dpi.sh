#!/bin/bas
echo " check /etc/xrdp/sesman.ini for XRDP_XORG_TOUCHPAD_SCROLL_HACK=yes in section [SessionVariables]"
xfconf-query -c xsettings -p /Gtk/FontName -s "Sans 10"
xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Monospace 10"
xfconf-query -c xsettings -p /Xft/DPI -n -t int -s 122
setxkbmap -option ctrl:nocaps
