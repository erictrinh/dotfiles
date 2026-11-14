# Sourced by husky before every hook. GUI git clients (GitHub Desktop) start
# with a minimal PATH that lacks Homebrew and fnm, so put the default node and
# Homebrew's pnpm on it.
export PATH="$HOME/.local/share/fnm/aliases/default/bin:/opt/homebrew/bin:$PATH"
