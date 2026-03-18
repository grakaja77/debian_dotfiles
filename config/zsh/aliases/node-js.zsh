######################################################################
# Node.js / NVM configuration                                        #
# Originally by Alicia Sykes, MIT licensed                          #
######################################################################

# NVM directory
export NVM_DIR="${HOME}/.config/nvm"
[[ ! -d "$NVM_DIR" && -d "$HOME/.nvm" ]] && export NVM_DIR="$HOME/.nvm"

# Lazy-load NVM for fast shell startup (~300ms savings)
if [[ -f "$NVM_DIR/nvm.sh" ]]; then
  __load_nvm() {
    unset -f node npm npx nvm yarn pnpm corepack __load_nvm 2>/dev/null
    source "$NVM_DIR/nvm.sh"
    # Default to LTS if no version active
    [[ "$(nvm current)" == "none" ]] && nvm use --lts --silent 2>/dev/null
  }
  for __cmd in node npm npx nvm yarn pnpm corepack; do
    eval "$__cmd() { __load_nvm; $__cmd \"\$@\"; }"
  done
  unset __cmd
fi

# Auto-init Node when entering a project directory
__auto_node() {
  # Check for node project markers
  local version_file=""
  [[ -f .nvmrc ]] && version_file=".nvmrc"
  [[ -f .node-version ]] && version_file=".node-version"

  if [[ -n "$version_file" || -f package.json ]]; then
    # Load NVM if still lazy-wrapped
    if typeset -f __load_nvm &>/dev/null; then
      __load_nvm
    fi
    # Switch version if specified in file
    if [[ -n "$version_file" ]]; then
      local target=$(<"$version_file")
      local current=$(node -v 2>/dev/null)
      [[ "$current" != "v${target#v}"* ]] && nvm use "$target" --silent 2>/dev/null
    fi
  fi
}
autoload -U add-zsh-hook
add-zsh-hook chpwd __auto_node

# ─── Aliases ───────────────────────────────────────────────────────
# Yarn
alias ys='yarn start'  yt='yarn test'    yb='yarn build'
alias yl='yarn lint'   yd='yarn dev'     yr='yarn run'
alias ya='yarn add'    ye='yarn remove'  yi='yarn install'

# NPM
alias npmi='npm install'  npmu='npm uninstall'  npmr='npm run'
alias npms='npm start'    npmt='npm test'       npmd='npm run dev'

# NVM
alias nvmi='nvm install'  nvmu='nvm use'  nvml='nvm ls'
alias nvmlts='nvm install --lts && nvm use --lts'

# Utils
alias yv='node -v && npm -v'
alias npmscripts='jq .scripts package.json 2>/dev/null'
alias nodesize='du -sh node_modules 2>/dev/null'
