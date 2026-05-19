[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# export Display settings
export DISPLAY=:0
systemctl --user import-environment DISPLAY XAUTHORITY
dbus-update-activation-environment --systemd DISPLAY XAUTHORITY

# exec openbox-session
# exec startfluxbox
xscreensaver --no-splash &
conky -p 3 &
exec awesome
