#!/bin/bash
xfconf-query -c xsettings -p /Gtk/FontName -s "Sans 12"
xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Monospace 12"
xfconf-query -c xsettings -p /Xft/DPI -n -t int -s 122
setxkbmap -option ctrl:nocaps
