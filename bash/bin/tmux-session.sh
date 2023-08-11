#!/bin/bash
# Create a new tmux session at the current directory with a session name of the directory

tmux=/usr/bin/tmux

path_name="$(basename "$PWD" | tr . -)"
sessionname="misc"

not_in_tmux() {
  [ -z "$TMUX" ]
}

session_exists() {
  $tmux has-session -t "=$sessionname"
}

create_detached_dev_session() {
  $tmux new-session -s $sessionname -d
}

if ! session_exists
then
  create_detached_dev_session
fi

if not_in_tmux 
then
  tmux attach -t $sessionname
else
  $tmux switch-client -t $sessionname
fi
