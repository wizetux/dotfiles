#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# set vi mode in bash
set -o vi

# Setup local bin in path
BIN_PATH=/home/wizetux/bin
if [[ $PATH != *"$BIN_PATH"* ]]; then
   echo "Updating path with home bin path"
   export PATH=$PATH:$BIN_PATH
fi

alias ls='ls --color=auto'
alias twitch-dl='youtube-dl -f 480p -o "%(title)s-%(uploader)s-%(upload_date)s.%(ext)s"'
alias tmux="TERM=screen-256color-bce tmux"
alias scanDoc="scanimage -d 'fujitsu:ScanSnap iX100:1213697' --format=jpeg --mode Color --resolution 300 | convert - -resize 35%"

source ~/.config/git_prompt/bash_profile_course
#PS1='[\u@\h \W]\$ '

#Set history file
export HISTFILE=~/.bash_history
export HISTFILESIZE=500000
export HISTSIZE=500000

#Remove duplicate and erase any previous duplicates from the history file.
export HISTCONTROL=ignoredups:erasedups

#Append the current session to the history file
shopt -s histappend

stty -ixon

function encodeMkv2Mp4
{
   if [ "${#}" != 2 ]; then
      echo "Usage: encodeMkv2Mp4 mkv_file mp4_file ";
      return 1;
   else
      ffmpeg -i ${1} -c:v h264_nvenc -preset llhq ${2};
   fi;
}
