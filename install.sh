sudo -v

# var to this directory
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# symlinks to set up caps lock as the super key
sh $dir/setup_super.sh

# install homebrew
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew bundle $dir/Brewfile
brew bundle $dir/Caskfile

# setup git stuff
git config --global user.name "Eric Trinh"
git config --global user.email "et.trinity@gmail.com"

# symlink subl
sudo ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/bin/subl

# symlink dotfiles into home
sudo gem install homesick
homesick clone erictrinh/dotfiles
homesick symlink dotfiles

curl -sSL https://get.rvm.io | bash


echo "Don't forget to disable caps lock key via System Preferences > Keyboard"
