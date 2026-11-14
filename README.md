# Install

To bootstrap a new system, run

```shell
/bin/zsh <(curl -fsSL https://raw.githubusercontent.com/erictrinh/dotfiles/master/install.sh)
```

This installs Homebrew, clones this repo into `~/dotfiles` (set `DOTFILES` to change that),
links the dotfiles, and installs everything in the `Brewfile`. You can also clone this repo
and run `./install.sh`.

# Managing dotfiles

`dot` symlinks everything in `home/` into `~`. It only needs zsh.

```shell
./dot link              # link home/ into ~ (safe to rerun; existing files are backed up to .bak.<timestamp>)
./dot track ~/.npmrc    # move a file or folder into home/, link it back, and git add it
./dot status            # any other arguments run git in this repo: dot pull, dot commit, ...
```

Each entry in `home/` is linked as a whole, so new files created inside a linked folder (for
example `~/.config` or `~/.hammerspoon`) appear in `git status` automatically. Use
`.gitignore` for app state you don't want committed.

Folders listed in `subdirs` are not linked themselves; their contents are linked one by one.
`dot track` adds entries there when you track a file inside a folder that isn't linked (for
example `~/.ssh/config`), so a new machine links just that file and not the whole folder.
