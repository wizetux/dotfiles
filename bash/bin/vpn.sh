#!/bin/bash
# Connect to work vpn in tmux session

tmux=/usr/bin/tmux
cmd=$@
session_name="vpn"

not_in_tmux() {
  [ -z "$TMUX" ]
}

session_exists() {
  $tmux has-session -t "=$session_name"
}

create_detached_dev_session() {
  $tmux new-session -ds $session_name $cmd
}

if ! session_exists
then
  create_detached_dev_session
fi

if not_in_tmux 
then
  tmux attach -t $session_name
else
  $tmux switch-client -t $session_name
fi
