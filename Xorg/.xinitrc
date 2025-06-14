[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# exec openbox-session
# exec startfluxbox
xscreensaver --no-splash &
conky -p 3 &
exec awesome
