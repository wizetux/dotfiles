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
  # Get current session width and height so that we can define this for the new session
  # This fixes the split-window not correctly setting the split size
  sessionWidth=$(tmux display-message -p '#{pane_width}')
  sessionHeight=$(tmux display-message -p '#{pane_height}')

  $tmux new-session -s $sessionname -d -x $sessionWidth -y $sessionHeight
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
