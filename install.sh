#!/bin/zsh
sudo -v

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap Homebrew/bundle
brew bundle

# setup zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

# symlink dotfiles into home
sudo gem install homesick
homesick clone erictrinh/dotfiles
homesick symlink dotfiles

thisdir=`homesick show_path dotfiles`

echo "Setting default shell to zsh"
chsh -s $(which zsh)

echo "Setting up wallpaper"
wallpaper="$thisdir/wallpaper/dlanham-SpaceDoggy3.jpg"

osascript <<EOF
tell application "Finder"
set desktop picture to POSIX file "$wallpaper"
end tell
EOF
