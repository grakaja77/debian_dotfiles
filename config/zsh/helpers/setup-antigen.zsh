# ZSH Plugin Setup
# Uses direct sourcing for speed - Antigen's caching is unreliable
# Plugins are stored in the antigen bundles directory for compatibility

antigen_dir=${ADOTDIR:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh/antigen}
antigen_bundles="${antigen_dir}/bundles"

# Function to install a plugin from GitHub if not present
_install_plugin() {
  local repo="$1"
  local dest="${antigen_bundles}/${repo}"
  if [[ ! -d "$dest" ]]; then
    echo "Installing ${repo}..."
    git clone --depth 1 "https://github.com/${repo}.git" "$dest" 2>/dev/null
  fi
}

# Install plugins if missing (only checks on first run or if deleted)
if [[ ! -d "${antigen_bundles}/zsh-users/zsh-syntax-highlighting" ]]; then
  mkdir -p "$antigen_bundles"
  _install_plugin "romkatv/powerlevel10k"
  _install_plugin "zsh-users/zsh-syntax-highlighting"
  _install_plugin "zsh-users/zsh-autosuggestions"
  _install_plugin "zsh-users/zsh-completions"
  _install_plugin "agkozak/zsh-z"
  _install_plugin "caarlos0/zsh-mkc"
  _install_plugin "supercrabtree/k"
fi

unfunction _install_plugin 2>/dev/null
