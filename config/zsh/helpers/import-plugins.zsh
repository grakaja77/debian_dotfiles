#!/usr/bin/env zsh

# Direct plugin loading - faster than Antigen
# Plugins are installed by setup-antigen.zsh if missing

_bundles="${ADOTDIR:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh/antigen}/bundles"

# Helper to source a plugin file if it exists
_src() { [[ -f "$1" ]] && source "$1"; }

# Powerlevel10k theme (instant prompt already loaded in .zshrc)
_src "$_bundles/romkatv/powerlevel10k/powerlevel10k.zsh-theme"

# Extra completions (add to fpath before compinit)
[[ -d "$_bundles/zsh-users/zsh-completions/src" ]] && \
  fpath=("$_bundles/zsh-users/zsh-completions/src" $fpath)

# Directory jumping with zsh-z
_src "$_bundles/agkozak/zsh-z/zsh-z.plugin.zsh"

# mkdir + cd in one command
_src "$_bundles/caarlos0/zsh-mkc/mkc.plugin.zsh"

# Pretty directory listings
_src "$_bundles/supercrabtree/k/k.sh"

# Autosuggestions (ghost text from history)
_src "$_bundles/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Syntax highlighting (must be last for best results)
_src "$_bundles/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

unfunction _src 2>/dev/null
unset _bundles