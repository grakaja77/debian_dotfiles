# .zshenv — loaded for EVERY shell (interactive, scripts, SSH, cron)
# Keep this lean: env vars and PATH only. No output, no prompts.

# ── Editor ──────────────────────────────────────────────────────────────────
export EDITOR='nano'
export VISUAL='nano'

# ── Path ────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ── XDG Base Dirs ───────────────────────────────────────────────────────────
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_BIN_HOME="$HOME/.local/bin"

# ── ZSH dirs (XDG-compliant) ───────────────────────────────────────────────
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export ZLIB="${ZDOTDIR}/lib"

# ── Respect XDG for various tools ──────────────────────────────────────────
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export WGETRC="${XDG_CONFIG_HOME}/wget/.wgetrc"
export CURL_HOME="${XDG_CONFIG_HOME}/curl"

# ── Less / Pager ────────────────────────────────────────────────────────────
export LESS='-RFX'              # color, quit-if-small, no-clear-on-exit
export LESSHISTFILE=/dev/null   # don't litter ~/ with .lesshst

# ── Locale ──────────────────────────────────────────────────────────────────
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
