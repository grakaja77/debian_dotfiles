# ── Zinit Plugin Manager Setup ───────────────────────────────────────────────
# Auto-installs zinit if not present, then loads plugins

ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

# Install zinit if missing
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
  print -P "%F{33}Installing zinit...%f"
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" 2>/dev/null
fi

source "${ZINIT_HOME}/zinit.zsh"

# ── Theme ───────────────────────────────────────────────────────────────────
# Powerlevel10k — loads immediately for instant prompt
zinit ice depth=1
zinit light romkatv/powerlevel10k

# ── Plugins (turbo mode — loads after prompt appears) ───────────────────────

# Completions (load early, before compinit)
zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# Autosuggestions (ghost text from history)
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# Syntax highlighting (must be near-last)
zinit ice wait lucid atinit'zicompinit; zicdreplay'
zinit light zsh-users/zsh-syntax-highlighting

# History substring search (type partial command, press up arrow)
zinit ice wait lucid
zinit light zsh-users/zsh-history-substring-search

# ── OMZ Plugins (loaded à la carte via zinit snippets) ──────────────────────

# sudo — press Esc twice to prepend sudo
zinit ice wait lucid
zinit snippet OMZP::sudo

# copypath — copy current directory path
zinit ice wait lucid
zinit snippet OMZP::copypath

# copyfile — copy file contents to clipboard
zinit ice wait lucid
zinit snippet OMZP::copyfile

# dirhistory — Alt+arrows to navigate directory history
zinit ice wait lucid
zinit snippet OMZP::dirhistory

# Directory jumping with zoxide (better than z/autojump)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi
