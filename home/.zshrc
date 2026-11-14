#
# Executes commands at the start of an interactive session.
#

# zmodload 'zsh/zprof'

# Vi key bindings. This has to run before zimfw loads the input module.
bindkey -v

# zimfw. Modules are listed in ~/.zimrc. The first shell after editing that
# file installs any new modules and rebuilds ~/.zim/init.zsh.
ZIM_HOME=${ZDOTDIR:-$HOME}/.zim
if [[ ! $ZIM_HOME/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-$HOME}/.zimrc} ]]; then
  source ${HOMEBREW_PREFIX:-/opt/homebrew}/opt/zimfw/share/zimfw.zsh init
fi
source $ZIM_HOME/init.zsh

# Settings kept from prezto that zim leaves out or sets differently.
setopt CLOBBER                # zim sets NO_CLOBBER, which stops > from overwriting files
setopt EXTENDED_HISTORY       # save timestamps in ~/.zsh_history
setopt HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS
setopt COMBINING_CHARS        # show accented filenames correctly on macOS
unsetopt FLOW_CONTROL         # free up Ctrl-S and Ctrl-Q

alias g='git'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias find='noglob find'      # so find . -name *.js works without quotes

# zim binds Up/Down to history-substring-search. Add j/k in vi normal mode.
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

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
      print -P "%F{blue}${app}%f uses %F{green}${sum}%f MBs of RAM."
    else
      print -P "There are no processes with pattern '%F{blue}${app}%f' are running."
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
