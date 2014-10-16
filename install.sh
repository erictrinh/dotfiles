#!/bin/zsh

sudo -v

# setup zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
git clone https://github.com/sindresorhus/pure.git "${ZDOTDIR:-$HOME}/.pure"
ln -s "${ZDOTDIR:-$HOME}/.pure/pure.zsh" "${ZDOTDIR:-$HOME}/.zprezto/modules/prompt/functions/prompt_pure_setup"

# symlink dotfiles into home
sudo gem install homesick
homesick clone erictrinh/dotfiles
homesick symlink dotfiles

thisdir=`homesick show_path dotfiles`

# symlinks to set up caps lock as the super key
sh $thisdir/setup_super.sh

# install homebrew
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew bundle $thisdir/Brewfile
brew bundle $thisdir/Caskfile

# symlink subl
sudo ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/bin/subl

curl -sSL https://get.rvm.io | bash

echo "Setting up wallpaper"
wallpaper="$thisdir/wallpaper/dlanham-Tinnitus.jpg"

osascript <<EOF
tell application "Finder"
set desktop picture to POSIX file "$wallpaper"
end tell
EOF

echo "Don't forget to disable caps lock key via System Preferences > Keyboard"
