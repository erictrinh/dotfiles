#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# zmodload 'zsh/zprof'

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# potential fix for subl command sometimes failing to open dirs
alias s="open -a 'Sublime Text'"
alias o="open -a 'Finder'"

# Short-cuts for copy-paste.
alias c='pbcopy'
alias p='pbpaste'

# Package managers.
alias ni='npm install'
alias nis='npm install --save'
alias nisd='npm install --save-dev'
alias nig='npm install --global'

# Defaults for mdfind
alias f='mdfind -onlyin .'

alias sw='git checkout $(git branch --sort=-committerdate | fzf --height 40%)'

# easy git cloning
function clone() {
  if [[ -n "$1" ]]; then
    git clone "git@github.com:$1.git"
  else
    echo "proper usage: clone <username/repo>"
  fi
}

# Show how much RAM application uses.
# $ ram safari
# # => safari uses 154.69 MBs of RAM.
function ram() {
  local sum
  local items
  local app="$1"
  if [ -z "$app" ]; then
    echo "First argument - pattern to grep from processes"
  else
    sum=0
    for i in `ps aux | grep -i "$app" | grep -v "grep" | awk '{print $6}'`; do
      sum=$(($i + $sum))
    done
    sum=$(echo "scale=2; $sum / 1024.0" | bc)
    if [[ $sum != "0" ]]; then
      echo "${fg[blue]}${app}${reset_color} uses ${fg[green]}${sum}${reset_color} MBs of RAM."
    else
      echo "There are no processes with pattern '${fg[blue]}${app}${reset_color}' are running."
    fi
  fi
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# zprof

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
