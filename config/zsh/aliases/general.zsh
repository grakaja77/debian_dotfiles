# ── Navigation ──────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias cdd='cd /opt/docker'

# ── Listing ─────────────────────────────────────────────────────────────────
if command -v eza &>/dev/null; then
  alias ls='eza --color=always --group-directories-first'
  alias ll='eza -lah --git --group-directories-first'
  alias la='eza -a --group-directories-first'
  alias l='eza -lh --group-directories-first'
  alias lt='eza -lah --sort=modified'        # sort by modified time
  alias tree='eza --tree --level=3'
else
  alias ls='ls --color=auto'
  alias ll='ls -lah'
  alias la='ls -A'
  alias l='ls -lh'
  alias lt='ls -lahtr'
fi

# ── Safety Nets ─────────────────────────────────────────────────────────────
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# ── Shell ────────────────────────────────────────────────────────────────────
alias c='clear'
alias h='history'
alias reload='source ~/.zshenv && source ${ZDOTDIR}/.zshrc'
alias zshrc='$EDITOR ${ZDOTDIR}/.zshrc'
alias path='echo $PATH | tr ":" "\n"'

# ── System ───────────────────────────────────────────────────────────────────
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install -y'
alias remove='sudo apt remove'
alias autoremove='sudo apt autoremove -y'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias mem='free -h | awk "/^Mem:/ {print \$3\"/\"\$2}"'
alias dmesg='dmesg --color=always | less -R'
alias services='systemctl list-units --type=service --state=running'
alias sctl='sudo systemctl'
alias jctl='sudo journalctl'
alias logs='sudo journalctl -f'
alias meminfo='free -m -l -t'
alias cpuinfo='lscpu'
alias distro='cat /etc/*-release'

# ── Networking ───────────────────────────────────────────────────────────────
alias ports='ss -tulnp'
alias myip='curl -s ifconfig.me && echo'
alias localip="hostname -I | awk '{print \$1}'"
alias ping='ping -c 5'
alias wget='wget -c'

# ── Files & Text ─────────────────────────────────────────────────────────────
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='diff --color=auto'
alias mkdir='mkdir -pv'

# bat — syntax-highlighted cat (falls back to plain cat)
if command -v bat &>/dev/null; then
  alias cat='bat --style=plain'
  alias catp='bat'
elif command -v batcat &>/dev/null; then
  alias cat='batcat --style=plain'
  alias catp='batcat'
fi

# fd — better find (Ubuntu/Debian installs as fdfind)
if command -v fd &>/dev/null; then
  alias find='fd'
elif command -v fdfind &>/dev/null; then
  alias fd='fdfind'
  alias find='fdfind'
fi

# ── Process ──────────────────────────────────────────────────────────────────
alias psa='ps aux'
alias psg='ps aux | grep -v grep | grep'
alias k9='kill -9'

# ── Docker (only if installed) ───────────────────────────────────────────────
if command -v docker &>/dev/null; then
  alias d='docker'
  alias dc='docker compose'
  alias dps='docker ps'
  alias dpsa='docker ps -a'
  alias dlog='docker logs -f'
  alias dex='docker exec -it'
  alias dprune='docker system prune -f'
fi

# ── Pipe shortcuts ───────────────────────────────────────────────────────────
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L='| less'
alias -g NE='2> /dev/null'
alias -g NUL='> /dev/null 2>&1'

# ── External Services ────────────────────────────────────────────────────────
alias weather='curl wttr.in'
alias weather-short='curl "wttr.in?format=3"'
alias cheat='curl cheat.sh/'

# ── Dotfiles ─────────────────────────────────────────────────────────────────
alias dotfiles="${DOTFILES_DIR:-$HOME/.dotfiles}/install.sh"
alias dots="dotfiles"
