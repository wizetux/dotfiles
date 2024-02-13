#!/bin/bash

# If the bashrc is not a symlink then we need to remove it
if ! [[ -h "$HOME/.bashrc" ]]; then
	rm "$HOME/.bashrc"
	rm "$HOME/.bash_profile"
	stow bash
fi

stow awesome
stow conky
stow nvim
stow tmux
stow Xorg
