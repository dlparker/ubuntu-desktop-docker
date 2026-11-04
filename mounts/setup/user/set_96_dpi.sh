#!/bin/bash
echo " check /etc/xrdp/sesman.ini for XRDP_XORG_TOUCHPAD_SCROLL_HACK=yes in section [SessionVariables]"
xfconf-query -c xsettings -p /Gtk/FontName -s "Sans 14"
xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Monospace 14"
xfconf-query -c xsettings -p /Xft/DPI -n -t int -s 96
setxkbmap -option ctrl:nocaps
