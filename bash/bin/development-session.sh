#!/bin/bash
# Create a new tmux session at the current directory with a session name of the directory

tmux=/usr/bin/tmux

path_name="$(basename "$PWD" | tr . -)"
sessionname=${1-$path_name}

not_in_tmux() {
  [ -z "$TMUX" ]
}

session_exists() {
  $tmux has-session -t "=$sessionname"
}

create_detached_dev_session() {
  $tmux new-session -s $sessionname -d
  $tmux split-window -t $sessionname -v -l 15
  $tmux select-pane -t $sessionname:0.1
  $tmux split-window -t $sessionname -h
  $tmux select-pane -t $sessionname:0.0
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
