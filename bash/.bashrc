#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# set vi mode in bash
set -o vi

export EDITOR=/usr/bin/nvim
export DISPLAY=:0

# Setup local bin in path
BIN_PATH="$HOME/bin"
if [[ $PATH != *"$BIN_PATH"* ]]; then
   echo "Updating path with home bin path"
   export PATH="$BIN_PATH:$PATH"
fi

if [[ $PATH != *"$HOME/.local/bin"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

alias ls='ls --color=auto'
alias twitch-dl='youtube-dl -f 480p -o "%(title)s-%(uploader)s-%(upload_date)s.%(ext)s"'
alias tmux="TERM=screen-256color-bce tmux"
alias scanDoc="scanimage -d 'fujitsu:ScanSnap iX100:1213697' --format=jpeg --mode Color --resolution 300 | magick - -resize 35%"
alias scanPdf="scanimage -d 'fujitsu:ScanSnap iX100:1213697' --format=jpeg --mode Color --resolution 300 | magick - "
alias dcd='docker-compose down --rmi local -v'
alias docker_prune='docker rmi $(docker images -f "dangling=true" -q)'
alias yt-dlp-mp3='yt-dlp -o "%(playlist_index)s - %(title)s.%(ext)s" -x --audio-format mp3 --embed-metadata --sleep-interval 5 --max-sleep-interval 10 '
alias connect_screen='xrandr --output DP-1 --auto && sleep 5 && xrandr --output DP-1 --mode 1920x1080 --above eDP-1 --primary'
alias disconnect_screen='xrandr --output DP-1 --off'
alias top_mem_proc='ps -eo %cpu,%mem,command --sort=-%mem | head -n 11'
alias top_cpu_proc='ps -eo %cpu,%mem,command --sort=-%cpu | head -n 11'

#source any other work related aliases
if [[ -f "$HOME/.work_aliases.sh" ]]; then
  source "$HOME/.work_aliases.sh" 
fi

source "$HOME/.config/git_prompt/bash_profile_course"

#PS1='[\u@\h \W]\$ '

#Set history file
export HISTFILE=~/.bash_history
export HISTFILESIZE=500000
export HISTSIZE=500000
export PLAYER_JOURNALS=/Steam/local/Steam/steamapps/compatdata/359320/pfx/drive_c/users/steamuser/Saved\ Games/Frontier\ Developments/Elite\ Dangerous/

#Remove duplicate and erase any previous duplicates from the history file.
export HISTCONTROL=ignoredups:erasedups

#Append the current session to the history file
shopt -s histappend

stty -ixon

# Setup SSH Agent for env.
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi

if [[ ! "$SSH_AUTH_SOCK" ]]; then
  source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

function gwa
{
   if [ "${#}" != 1 ]; then
      echo "Usage: gwa <branch-name>";
      return 1;
   else
      git worktree add --track -b "${1}" "${1}" "origin/${1}";
   fi;
}

function encodeMkv2Mp4
{
   if [ "${#}" != 2 ]; then
      echo "Usage: encodeMkv2Mp4 mkv_file mp4_file ";
      return 1;
   else
      ffmpeg -i ${1} -c:v h264_nvenc -preset llhq ${2};
   fi;
}
