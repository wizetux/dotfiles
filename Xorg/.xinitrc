[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# export Display settings
export DISPLAY=:0

# exec openbox-session
# exec startfluxbox
xscreensaver --no-splash &
conky -p 3 &
exec awesome
