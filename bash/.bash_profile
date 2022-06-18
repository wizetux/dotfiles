#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# If logging in through an ssh connection and not already in our TMUX session,
# automatically attach
if [ -n "$SSH_CLIENT" -a -z "$TMUX" ]; then
  /usr/bin/tmux attach -d
fi
