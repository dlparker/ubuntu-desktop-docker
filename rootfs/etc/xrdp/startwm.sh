#!/bin/sh
# Custom xrdp session start: launch XFCE under dbus.
if [ -r /etc/default/locale ]; then
    . /etc/default/locale
    export LANG LANGUAGE
fi
unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR

( sleep 1 && \
      xfconf-query -c xsettings -p /Gtk/FontName -s "Sans 14" || true && \
      xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Monospace 14" || true && \
      xfconf-query -c xsettings -p /Net/ThemeName -n -t string -s "Adwaita" && \
      xfconf-query -c xsettings -p /Net/IconThemeName -n -t string -s "Adwaita" && \
      xfconf-query -c xfce4-terminal -p /color-use-theme -n -t bool -s true && \      
      setxkbmap -option ctrl:nocaps  \
	  ) &


mkdir -p "$HOME/.local/bin" "$HOME/.local/share/applications"
cat > "$HOME/.local/bin/xfce4-terminal-themed" << 'EOF'
#!/bin/sh
xfconf-query -c xfce4-terminal -p /color-use-theme -n -t bool -s true
exec /usr/bin/xfce4-terminal "$@"
EOF
chmod +x "$HOME/.local/bin/xfce4-terminal-themed"
cp /usr/share/applications/xfce4-terminal.desktop "$HOME/.local/share/applications/"
sed -i "s|^Exec=.*|Exec=$HOME/.local/bin/xfce4-terminal-themed|" "$HOME/.local/share/applications/xfce4-terminal.desktop"
echo "TerminalEmulator=xfce4-terminal" > ~/.config/xfce4/helpers.rc

exec dbus-launch --exit-with-session startxfce4




