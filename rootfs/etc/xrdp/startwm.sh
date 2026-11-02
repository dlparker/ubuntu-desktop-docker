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


# Audio for xrdp session
export XDG_RUNTIME_DIR="/tmp/runtime-${USER}"
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

(
  ulimit -n 65536
  pipewire > /tmp/pipewire.log 2>&1 &
  # wait for the pipewire socket
  for i in $(seq 1 20); do
    [ -S "$XDG_RUNTIME_DIR/pipewire-0" ] && break
    sleep 0.5
  done
  wireplumber > /tmp/wireplumber.log 2>&1 &
  sleep 1
  pipewire-pulse > /tmp/pipewire-pulse.log 2>&1 &
  # wait for the pulse socket
  for i in $(seq 1 20); do
    [ -S "$XDG_RUNTIME_DIR/pulse/native" ] && break
    sleep 0.5
  done
  # load the xrdp sink/source the way the package expects
  /usr/libexec/pipewire-module-xrdp/load_pw_modules.sh > /tmp/xrdp-module.log 2>&1
) &
exec dbus-launch --exit-with-session startxfce4




