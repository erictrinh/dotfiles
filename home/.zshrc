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

alias o="open -a 'Finder'"

# Short-cuts for copy-paste.
alias c='pbcopy'
alias p='pbpaste'

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

# zprof

# fzf key bindings (Ctrl-R, Ctrl-T, Alt-C). Skip without a terminal, e.g. when
# an editor runs zsh -i just to read the environment.
[[ -t 0 && -t 1 ]] && (( $+commands[fzf] )) && source <(fzf --zsh)

# Node: on cd, switch to the version in the nearest .nvmrc or .node-version
# (searching parent folders), and back to the default outside a project.
if (( $+commands[fnm] )); then
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines=false --shell zsh)"
fi

eval "$(zoxide init zsh)"
# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

export PATH="$HOME/.local/bin:$PATH"
