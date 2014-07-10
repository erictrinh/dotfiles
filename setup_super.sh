dir="$( cd "$( dirname "$0" )" && pwd )"

for entry in "$dir/prefs"/*.plist; do
  echo "Creating symlink to ${entry##*/} ~/Library/Preferences directory."
  ln -s $entry ~/Library/Preferences/${entry##*/}
done

mkdir -p ~/Library/Application\ Support/Karabiner
ln -s $dir/prefs/private.xml ~/Library/Application\ Support/Karabiner/private.xml
