THIS_DIR="$( cd "$( dirname "$0" )" && pwd )"
SUBLIME_PATH="$HOME/Applications"
SUBLIME_3_NAME="Sublime Text.app"

sudo cp "$THIS_DIR/SublimeText.icns" "$SUBLIME_PATH/$SUBLIME_3_NAME/Contents/Resources/Sublime Text.icns"

# trigger refresh of app icon
SUBLIME_COPY="SUBLIME COPY"
cd -P "$SUBLIME_PATH/$SUBLIME_3_NAME/.."
sudo cp -r "$SUBLIME_3_NAME" "$SUBLIME_COPY"
sudo rm -rf "$SUBLIME_3_NAME"
sudo mv "$SUBLIME_COPY" "$SUBLIME_3_NAME"
