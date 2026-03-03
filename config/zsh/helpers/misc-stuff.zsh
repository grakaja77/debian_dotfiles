# Initialize thefuck (if installed and working)
# Wrapped in subshell to suppress errors from Python compatibility issues
if command -v thefuck &> /dev/null; then
  _thefuck_alias=$(thefuck --alias 2>/dev/null)
  [[ -n "$_thefuck_alias" ]] && eval "$_thefuck_alias"
  unset _thefuck_alias
fi

# Fix default editor, for systems without nvim installed
if ! hash nvim 2> /dev/null; then
  alias nvim='vim'
fi
