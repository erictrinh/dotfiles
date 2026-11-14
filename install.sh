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

# mas can only install App Store apps after you sign in, and it can't check whether you have.
open -a "App Store"
read -r "?Sign in to the App Store, then press Return to continue. "

# Apps and CLI tools. One failed cask shouldn't stop the rest of the setup.
brew bundle --file="$DOTFILES/Brewfile" || print -u2 "brew bundle had failures; rerun it once setup finishes"

# Node: install the current LTS with fnm and make it the default.
fnm install --lts
fnm default lts-latest

# Prezto
if [[ ! -d ${ZDOTDIR:-$HOME}/.zprezto ]]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi

echo "Enabling dark mode"
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

echo "Setting wallpaper"
osascript -e "tell application \"System Events\" to tell every desktop to set picture to POSIX file \"$DOTFILES/wallpaper/dlanham-SpaceDoggy3.jpg\""

# Tailscale: put its CLI on PATH (same as the app's "Install CLI" option), then
# open the app to log in.
if [[ -d /Applications/Tailscale.app ]]; then
  sudo mkdir -p /usr/local/bin
  printf '#!/bin/sh\nexec /Applications/Tailscale.app/Contents/MacOS/Tailscale "$@"\n' | sudo tee /usr/local/bin/tailscale >/dev/null
  sudo chmod 755 /usr/local/bin/tailscale
  open -a Tailscale
  echo "Log in to Tailscale from its menu bar icon and allow the VPN configuration when macOS asks."
fi

echo "Done. Open a new terminal window to load the shell config."
