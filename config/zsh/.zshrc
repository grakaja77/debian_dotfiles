# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

######################################################################
# ~/.config/zsh/.zshrc                                               #
######################################################################
# Instructions to be executed when a new ZSH session is launched     #
# Imports all plugins, aliases, helper functions, and configurations #
#                                                                    #
# After editing, re-source .zshrc for new changes to take effect     #
# For docs and more info, see: https://github.com/lissy93/dotfiles   #
######################################################################
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> #
######################################################################

# Directory for all-things ZSH config
zsh_dir=${${ZDOTDIR}:-$HOME/.config/zsh}
utils_dir="${XDG_CONFIG_HOME}/utils"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Import utility functions (if present)
# Helper function to safely source files
function _safe_source() {
  [[ -f "$1" ]] && source "$1"
}

if [[ -d $utils_dir ]]; then
  _safe_source "${utils_dir}/transfer.sh"
  _safe_source "${utils_dir}/matrix.sh"
  _safe_source "${utils_dir}/hr.sh"
  _safe_source "${utils_dir}/web-search.sh"
  _safe_source "${utils_dir}/am-i-online.sh"
  _safe_source "${utils_dir}/welcome-banner.sh"
  _safe_source "${utils_dir}/color-map.sh"
fi

# MacOS-specific services
if [ "$(uname -s)" = "Darwin" ]; then
  # Add Brew to path, if it's installed
  if [[ -d /opt/homebrew/bin ]]; then
    export PATH=/opt/homebrew/bin:$PATH
  fi

  # If using iTerm, import the shell integration if availible
  if [[ -f "${XDG_CONFIG_HOME}/zsh/.iterm2_shell_integration.zsh" ]]; then
    source "${XDG_CONFIG_HOME}/zsh/.iterm2_shell_integration.zsh"
  fi

  # Append the Android SDK locations to path
  if [[ -d "${HOME}/Library/Android/" ]]; then
    export PATH="${HOME}/Library/Android/sdk/emulator:${PATH}"
    export ANDROID_HOME="${HOME}/Library/Android/sdk"
    export ANDROID_SDK_ROOT="${HOME}/Library/Android/sdk"
    export ANDROID_AVD_HOME="${ANDROID_SDK_ROOT}/tools/emulator"
    export NODE_BINARY="/usr/local/bin/node"
  fi
fi


# Source all ZSH config files (if present)
if [[ -d $zsh_dir ]]; then
  # Import alias files
  _safe_source "${zsh_dir}/aliases/general.zsh"
  _safe_source "${zsh_dir}/aliases/git.zsh"
  _safe_source "${zsh_dir}/aliases/node-js.zsh"
  _safe_source "${zsh_dir}/aliases/rust.zsh"
  _safe_source "${zsh_dir}/aliases/flutter.zsh"
  _safe_source "${zsh_dir}/aliases/tmux.zsh"
  _safe_source "${zsh_dir}/aliases/alias-tips.zsh"

  # Setup Antigen, and import plugins
  _safe_source "${zsh_dir}/helpers/setup-antigen.zsh"
  _safe_source "${zsh_dir}/helpers/import-plugins.zsh"
  _safe_source "${zsh_dir}/helpers/misc-stuff.zsh"

  # Configure ZSH stuff
  _safe_source "${zsh_dir}/lib/colors.zsh"
  _safe_source "${zsh_dir}/lib/cursor.zsh"
  _safe_source "${zsh_dir}/lib/history.zsh"
  _safe_source "${zsh_dir}/lib/surround.zsh"
  _safe_source "${zsh_dir}/lib/completion.zsh"
  _safe_source "${zsh_dir}/lib/term-title.zsh"
  _safe_source "${zsh_dir}/lib/navigation.zsh"
  _safe_source "${zsh_dir}/lib/expansions.zsh"
  _safe_source "${zsh_dir}/lib/key-bindings.zsh"
fi

# If using Pyenv, import the shell integration if availible
if [[ -d "$PYENV_ROOT" ]] && \
  command -v pyenv >/dev/null 2>&1 && \
  command -v pyenv-virtualenv-init >/dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# If using Tilix, import the shell integration if availible
if [ $TILIX_ID ] || [ $VTE_VERSION ] && [[ -f "/etc/profile.d/vte.sh" ]]; then
  source /etc/profile.d/vte.sh
fi

# Append Cargo to path, if it's installed
if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Append Deno to path, if it's installed
if [[ -d "$HOME/.deno" ]]; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

# NVM (Node Version Manager) - lazy load for performance
# export NVM_DIR="$HOME/.config/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Add local bin to PATH (if directory exists)
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# Add Zoxide (for cd, quick jump) to shell
if hash zoxide 2> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# If not running in nested shell, then show welcome message :)
# if [[ "${SHLVL}" -lt 2 ]] && \
#   { [[ -z "$SKIP_WELCOME" ]] || [[ "$SKIP_WELCOME" == "false" ]]; }; then
#   welcome
# fi

# Bun completions (if installed)
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# Deno environment (if installed)
[[ -f "$HOME/.deno/env" ]] && source "$HOME/.deno/env"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
