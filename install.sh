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
if (( $+commands[fnm] )); then
  fnm install --lts
  fnm default lts-latest
else
  print -u2 "fnm isn't installed, so Node was skipped; rerun brew bundle, then: fnm install --lts && fnm default lts-latest"
fi

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
