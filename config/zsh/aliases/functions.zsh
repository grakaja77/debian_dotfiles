# ── File & Directory ─────────────────────────────────────────────────────────

# mkdir and cd in one step
mkcd() { mkdir -p "$1" && cd "$1"; }

# cd into a dir then list it
cl() { cd "$1" && ll; }

# Extract any archive format
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)  tar xjf "$1"    ;;
      *.tar.gz)   tar xzf "$1"    ;;
      *.tar.xz)   tar xJf "$1"    ;;
      *.tar.zst)  tar --zstd -xf "$1" ;;
      *.bz2)      bunzip2 "$1"    ;;
      *.gz)       gunzip "$1"     ;;
      *.tar)      tar xf "$1"     ;;
      *.tbz2)     tar xjf "$1"    ;;
      *.tgz)      tar xzf "$1"    ;;
      *.zip)      unzip "$1"      ;;
      *.7z)       7z x "$1"       ;;
      *.xz)       unxz "$1"       ;;
      *)          echo "'$1' — unknown archive format" ;;
    esac
  else
    echo "'$1' is not a file"
  fi
}

# ── Search ───────────────────────────────────────────────────────────────────

# Search file contents recursively, usage: ftext "pattern"
ftext() { grep -rnI --color=auto "$1" .; }

# Find files by name, usage: ff "*.log"
ff() { find . -type f -name "$1"; }

# ── Networking ───────────────────────────────────────────────────────────────

# Show open ports with the process name
listening() {
  if command -v ss &>/dev/null; then
    sudo ss -tulnp
  else
    sudo netstat -tulnp
  fi
}

# Simple HTTP server in current directory
serve() {
  local port="${1:-8000}"
  echo "Serving on http://0.0.0.0:$port"
  python3 -m http.server "$port"
}

# ── System ───────────────────────────────────────────────────────────────────

# Show top 10 largest files/dirs in current directory
biggest() { du -ah --max-depth=1 "${1:-.}" | sort -rh | head -11 | tail -10; }

# Repeat a command N times, usage: rep 5 echo "hi"
rep() {
  local n="$1"; shift
  for _ in $(seq 1 "$n"); do "$@"; done
}

# ── Git ──────────────────────────────────────────────────────────────────────

# Clone and immediately cd into the repo
gclone() { git clone "$1" && cd "$(basename "$1" .git)"; }

# Show a summary of what changed in the last N commits (default 1)
gwhat() {
  local n="${1:-1}"
  git diff --stat "HEAD~${n}..HEAD"
}

# ── Process ──────────────────────────────────────────────────────────────────

# Kill process by name
psgrep() { ps aux | grep -v grep | grep -i "$1"; }
pskill() { kill -9 "$(pgrep -f "$1")"; }
