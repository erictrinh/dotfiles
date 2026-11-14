#!/bin/zsh
# Bootstrap a new Mac: Homebrew, dotfiles, apps, shell.
set -euo pipefail

# Use this clone if the script is run from one; otherwise (curl) clone into ~/dotfiles.
if [[ -x ${0:A:h}/dot ]]; then
  DOTFILES=${0:A:h}
else
  DOTFILES=${DOTFILES:-$HOME/dotfiles}
fi

sudo -v

# Homebrew. Its installer also installs the Xcode Command Line Tools, which provide git.
if [[ ! -x /opt/homebrew/bin/brew ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# Dotfiles
if [[ ! -d $DOTFILES/.git ]]; then
  git clone https://github.com/erictrinh/dotfiles.git "$DOTFILES"
fi
"$DOTFILES/dot" link

# Apps and CLI tools. One failed cask shouldn't stop the rest of the setup.
brew bundle --file="$DOTFILES/Brewfile" || print -u2 "brew bundle had failures; rerun it once setup finishes"

# Prezto
if [[ ! -d ${ZDOTDIR:-$HOME}/.zprezto ]]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

echo "Enabling dark mode"
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

echo "Setting wallpaper"
osascript -e "tell application \"System Events\" to tell every desktop to set picture to POSIX file \"$DOTFILES/wallpaper/dlanham-SpaceDoggy3.jpg\""

echo "Done. Open a new terminal window to load the shell config."
