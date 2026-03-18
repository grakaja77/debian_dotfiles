# Enable Powerlevel10k instant prompt (must stay near top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

########################################################################
# ~/.config/zsh/.zshrc                                                  #
# ZSH config using zinit plugin manager                                 #
# https://github.com/grakaja77/debian_dotfiles                         #
########################################################################

# ── Greeting ─────────────────────────────────────────────────────────
command -v fastfetch &>/dev/null && fastfetch

# ── Core directories ─────────────────────────────────────────────────
zsh_dir=${ZDOTDIR:-$HOME/.config/zsh}
utils_dir="${XDG_CONFIG_HOME}/utils"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Helper to safely source files
_safe_source() { [[ -f "$1" ]] && source "$1"; }

# ── Homebrew (Linux) ─────────────────────────────────────────────────
if [[ -d /home/linuxbrew/.linuxbrew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# ── Zinit + Plugins ──────────────────────────────────────────────────
_safe_source "${zsh_dir}/helpers/setup-zinit.zsh"

# ── History ──────────────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY

# ── Completion ───────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# ── Key Bindings ─────────────────────────────────────────────────────
bindkey '^[[A' history-substring-search-up    2>/dev/null || bindkey '^[[A' up-line-or-history
bindkey '^[[B' history-substring-search-down  2>/dev/null || bindkey '^[[B' down-line-or-history
bindkey '^[[1;5C' forward-word                # Ctrl+Right
bindkey '^[[1;5D' backward-word               # Ctrl+Left
bindkey '^R'      history-incremental-search-backward
bindkey '^A'      beginning-of-line
bindkey '^E'      end-of-line
bindkey '^[[3~'   delete-char                 # Delete key

# ── Autosuggestions config ───────────────────────────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ── Aliases & Functions ──────────────────────────────────────────────
if [[ -d $zsh_dir ]]; then
  _safe_source "${zsh_dir}/aliases/general.zsh"
  _safe_source "${zsh_dir}/aliases/git.zsh"
  _safe_source "${zsh_dir}/aliases/functions.zsh"
  _safe_source "${zsh_dir}/aliases/node-js.zsh"
  _safe_source "${zsh_dir}/aliases/rust.zsh"
  _safe_source "${zsh_dir}/aliases/flutter.zsh"
fi

# ── Utility scripts (if present) ────────────────────────────────────
if [[ -d $utils_dir ]]; then
  _safe_source "${utils_dir}/transfer.sh"
  _safe_source "${utils_dir}/web-search.sh"
  _safe_source "${utils_dir}/am-i-online.sh"
fi

# ── fzf (if installed) ──────────────────────────────────────────────
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ── Cargo (if installed) ────────────────────────────────────────────
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"

# ── Local bin ────────────────────────────────────────────────────────
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# ── Powerlevel10k config ─────────────────────────────────────────────
[[ ! -f "${zsh_dir}/.p10k.zsh" ]] || source "${zsh_dir}/.p10k.zsh"
