#!/usr/bin/env bash

######################################################################
# Debian Dotfiles - All-in-One Install and Setup Script              #
######################################################################
# Fetches latest changes, symlinks files, and installs dependencies  #
# Then sets up ZSH and applies system preferences                    #
#                                                                    #
# OPTIONS:                                                           #
#   --auto-yes: Skip all prompts, and auto-accept all changes        #
#   --no-clear: Don't clear the screen before running                #
#                                                                    #
# ENVIRONMENTAL VARIABLES:                                           #
#   DOTFILES_DIR: Where to save dotfiles to (default: ~/.dotfiles)   #
#   DOTFILES_REPO: Git repo to use (default: grakaja77/debian_dotfiles) #
######################################################################

# Set variables for reference
PARAMS=$* # User-specified parameters
CURRENT_DIR=$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)
PROMPT_TIMEOUT=15 # When user is prompted for input, skip after x seconds
START_TIME=`date +%s` # Start timer
SRC_DIR=$(dirname ${0})

# Dotfiles Source Repo and Destination Directory
REPO_NAME="${REPO_NAME:-grakaja77/debian_dotfiles}"
DOTFILES_DIR="${DOTFILES_DIR:-${SRC_DIR:-$HOME/.dotfiles}}"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/${REPO_NAME}.git}"

# Config Names and Locations
TITLE="🧰 ${REPO_NAME} Setup"
SYMLINK_FILE="${SYMLINK_FILE:-symlinks.yaml}"
DOTBOT_DIR="lib/dotbot"
DOTBOT_BIN="bin/dotbot"

# Color Variables
CYAN_B='\033[1;96m'
YELLOW_B='\033[1;93m'
RED_B='\033[1;31m'
GREEN_B='\033[1;32m'
PLAIN_B='\033[1;37m'
RESET='\033[0m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'

# Clear the screen
if [[ ! $PARAMS == *"--no-clear"* ]] && [[ ! $PARAMS == *"--help"* ]] ; then
  clear
fi

# If set to auto-yes - then don't wait for user reply
if [[ $PARAMS == *"--auto-yes"* ]]; then
  PROMPT_TIMEOUT=1
  AUTO_YES=true
fi

# Function that prints important text in a banner with colored border
make_banner () {
  bannerText=$1
  lineColor="${2:-$CYAN_B}"
  padding="${3:-0}"
  titleLen=$(expr ${#bannerText} + 2 + $padding);
  lineChar="─"; line=""
  for (( i = 0; i < "$titleLen"; ++i )); do line="${line}${lineChar}"; done
  banner="${lineColor}╭${line}╮\n│ ${PLAIN_B}${bannerText}${lineColor} │\n╰${line}╯"
  echo -e "\n${banner}\n${RESET}"
}

# Explain to the user what changes will be made
make_intro () {
  C2="\033[0;35m"
  C3="\x1b[2m"
  echo -e "${CYAN_B}The setup script will do the following:${RESET}\n"\
  "${C2}(1) Pre-Setup Tasks\n"\
  "  ${C3}- Check that all requirements are met, and system is compatible\n"\
  "  ${C3}- Sets environmental variables from params, or uses sensible defaults\n"\
  "  ${C3}- Output welcome message and summary of changes\n"\
  "${C2}(2) Setup Dotfiles\n"\
  "  ${C3}- Clone or update dotfiles from git\n"\
  "  ${C3}- Symlinks dotfiles to correct locations\n"\
  "${C2}(3) Install packages\n"\
  "  ${C3}- On Debian, updates and installs packages via apt\n"\
  "  ${C3}- Prompt to install Homebrew if not present\n"\
  "  ${C3}- Install Homebrew packages from Brewfile\n"\
  "  ${C3}- On desktop systems, prompt to install apps via Flatpak\n"\
  "${C2}(4) Configure system\n"\
  "  ${C3}- Setup ZSH as default shell\n"\
  "  ${C3}- Apply desktop preferences via dconf (if running a desktop)\n"\
  "${C2}(5) Finishing Up\n"\
  "  ${C3}- Refresh current terminal session\n"\
  "  ${C3}- Print summary of applied changes and time taken\n"\
  "  ${C3}- Exit with appropriate status code\n\n"\
  "${PURPLE}You will be prompted at each stage, before any changes are made.${RESET}\n"\
  "${PURPLE}For more info, see GitHub: \033[4;35mhttps://github.com/${REPO_NAME}${RESET}"
}

# Cleanup tasks, run when the script exits
cleanup () {
  unset PROMPT_TIMEOUT
  unset AUTO_YES
}

# Checks if a given package is installed
command_exists () {
  hash "$1" 2> /dev/null
}

# On error, displays death banner, and terminates app with exit code 1
terminate () {
  make_banner "Installation failed. Terminating..." ${RED_B}
  exit 1
}

# Checks if command / package (in $1) exists and then shows
# either shows a warning or error, depending if package required ($2)
system_verify () {
  if ! command_exists $1; then
    if $2; then
      echo -e "🚫 ${RED_B}Error:${PLAIN_B} $1 is not installed${RESET}"
      terminate
    else
      echo -e "⚠️  ${YELLOW_B}Warning:${PLAIN_B} $1 is not installed${RESET}"
    fi
  fi
}

# Shows a desktop notification, on compatible systems
show_notification () {
  if [[ $PARAMS == *"--no-notifications"* ]]; then return; fi
  notif_title=$TITLE
  notif_logo="${DOTFILES_DIR}/.github/logo.png"
  if command_exists notify-send; then
    notify-send -u normal -t 15000 -i "${notif_logo}" "${notif_title}" "${1}"
  fi
}

# Prints welcome banner, verifies that requirements are met
function pre_setup_tasks () {
  make_banner "${TITLE}" "${CYAN_B}" 1

  # Print intro, listing what changes will be applied
  make_intro

  # Confirm that the user would like to proceed
  echo -e "\n${CYAN_B}Are you happy to continue? (y/N)${RESET}"
  read -t $PROMPT_TIMEOUT -n 1 -r ans_start
  if [[ ! $ans_start =~ ^[Yy]$ ]] && [[ $AUTO_YES != true ]] ; then
    echo -e "\n${PURPLE}No worries, feel free to come back another time."\
    "\nTerminating...${RESET}"
    make_banner "🚧 Installation Aborted" ${YELLOW_B} 1
    exit 0
  fi
  echo

  # If pre-requisite packages not found, prompt to install
  if ! command_exists git; then
    sudo apt-get update && sudo apt-get install -y git curl
  fi

  # Verify required packages are installed
  system_verify "git" true
  system_verify "zsh" false

  # If XDG variables aren't yet set, then configure defaults
  if [ -z ${XDG_CONFIG_HOME+x} ]; then
    echo -e "${YELLOW_B}XDG_CONFIG_HOME is not yet set. Will use ~/.config${RESET}"
    export XDG_CONFIG_HOME="${HOME}/.config"
  fi
  if [ -z ${XDG_DATA_HOME+x} ]; then
    echo -e "${YELLOW_B}XDG_DATA_HOME is not yet set. Will use ~/.local/share${RESET}"
    export XDG_DATA_HOME="${HOME}/.local/share"
  fi

  # Ensure dotfiles source directory is set and valid
  if [[ ! -d "$SRC_DIR" ]] && [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${YELLOW_B}Destination directory not set,"\
    "defaulting to $HOME/.dotfiles\n"\
    "${CYAN_B}To specify where you'd like dotfiles to be downloaded to,"\
    "set the DOTFILES_DIR environmental variable, and re-run.${RESET}"
    DOTFILES_DIR="${HOME}/.dotfiles"
  fi
}

# Downloads / updates dotfiles and symlinks them
function setup_dot_files () {
  # If dotfiles not yet present, clone the repo
  if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${PURPLE}Dotfiles not yet present."\
    "Downloading ${REPO_NAME} into ${DOTFILES_DIR}${RESET}"
    echo -e "${YELLOW_B}You can change where dotfiles will be saved to,"\
    "by setting the DOTFILES_DIR env var${RESET}"
    mkdir -p "${DOTFILES_DIR}" && \
    git clone --recursive ${DOTFILES_REPO} ${DOTFILES_DIR} && \
    cd "${DOTFILES_DIR}"
  else # Dotfiles already downloaded, just fetch latest changes
    echo -e "${PURPLE}Pulling changes from ${REPO_NAME} into ${DOTFILES_DIR}${RESET}"
    cd "${DOTFILES_DIR}" && \
    git pull origin master && \
    echo -e "${PURPLE}Updating submodules${RESET}" && \
    git submodule update --recursive --remote --init
  fi

  # If git clone / pull failed, then exit with error
  if ! test "$?" -eq 0; then
    echo -e >&2 "${RED_B}Failed to fetch dotfiles from git${RESET}"
    terminate
  fi

  # Set up symlinks with dotbot
  echo -e "${PURPLE}Setting up Symlinks${RESET}"
  cd "${DOTFILES_DIR}"
  git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
  git submodule update --init --recursive "${DOTBOT_DIR}"
  chmod +x  lib/dotbot/bin/dotbot
  "${DOTFILES_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${DOTFILES_DIR}" -c "${SYMLINK_FILE}" "${@}"
}

# Applies application-specific preferences
function apply_preferences () {
  # If ZSH not the default shell, ask user if they'd like to set it
  if [[ $SHELL != *"zsh"* ]] && command_exists zsh; then
    echo -e "\n${CYAN_B}Would you like to set ZSH as your default shell? (y/N)${RESET}"
    read -t $PROMPT_TIMEOUT -n 1 -r ans_zsh
    if [[ $ans_zsh =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
      echo -e "${PURPLE}Setting ZSH as default shell${RESET}"
      chsh -s $(which zsh) $USER
    fi
  fi

  # Prompt user to install / update ZSH plugins via zinit
  echo -e "\n${CYAN_B}Would you like to install / update ZSH plugins? (y/N)${RESET}"
  read -t $PROMPT_TIMEOUT -n 1 -r ans_cliplugins
  if [[ $ans_cliplugins =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
    echo -e "${PURPLE}Installing ZSH Plugins via zinit${RESET}"
    /bin/zsh -i -c "zinit self-update && zinit update --all"
  fi

  # Apply desktop preferences via dconf (if running a desktop environment)
  if [ ! -z "$XDG_CURRENT_DESKTOP" ]; then
    echo -e "\n${CYAN_B}Would you like to apply desktop preferences via dconf? (y/N)${RESET}"
    read -t $PROMPT_TIMEOUT -n 1 -r ans_syspref
    if [[ $ans_syspref =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]]; then
      echo -e "\n${PURPLE}Applying dconf preferences${RESET}\n"
      dconf_script="$DOTFILES_DIR/scripts/linux/dconf-prefs.sh"
      chmod +x $dconf_script && $dconf_script
    fi
  fi
}

# Install Homebrew and packages from Brewfile
function install_homebrew_packages () {
  if ! command_exists brew; then
    echo -e "\n${CYAN_B}Would you like to install Homebrew? (y/N)${RESET}"
    read -t $PROMPT_TIMEOUT -n 1 -r ans_homebrewins
    if [[ $ans_homebrewins =~ ^[Yy]$ ]] || [[ $AUTO_YES = true ]] ; then
      echo -en "🍺 ${PURPLE}Installing Homebrew...${RESET}\n"
      brew_url='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
      /bin/bash -c "$(curl -fsSL $brew_url)"
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
  fi
  # Update / Install the Homebrew packages from Brewfile
  if command_exists brew && [ -f "$DOTFILES_DIR/scripts/installs/Brewfile" ]; then
    echo -e "\n${PURPLE}Updating Homebrew and packages...${RESET}"
    brew update
    brew upgrade
    brew bundle --file "$DOTFILES_DIR/scripts/installs/Brewfile"
    brew cleanup
  else
    echo -e "${PURPLE}Skipping Homebrew as requirements not met${RESET}"
  fi
}

# Install system packages via apt, Homebrew, and optionally Flatpak
function install_packages () {
  echo -e "\n${CYAN_B}Would you like to install / update system packages? (y/N)${RESET}"
  read -t $PROMPT_TIMEOUT -n 1 -r ans_syspackages
  if [[ ! $ans_syspackages =~ ^[Yy]$ ]] && [[ $AUTO_YES != true ]] ; then
    echo -e "\n${PURPLE}Skipping package installs${RESET}"
    return
  fi

  # Debian packages via apt
  if [ -f "/etc/debian_version" ]; then
    debian_pkg_install_script="${DOTFILES_DIR}/scripts/installs/debian-apt.sh"
    chmod +x $debian_pkg_install_script
    $debian_pkg_install_script $PARAMS
  fi

  # Homebrew packages
  install_homebrew_packages

  # If running a Linux desktop, prompt to install desktop apps via Flatpak
  flatpak_script="${DOTFILES_DIR}/scripts/installs/flatpak.sh"
  if [ ! -z "$XDG_CURRENT_DESKTOP" ] && [ -f "$flatpak_script" ]; then
    chmod +x $flatpak_script
    $flatpak_script $PARAMS
  fi
}

# Updates current session, and outputs summary
function finishing_up () {
  # Update source to ZSH entry point
  source "${HOME}/.zshenv"

  # Calculate time taken
  total_time=$((`date +%s`-START_TIME))
  if [[ $total_time -gt 60 ]]; then
    total_time="$(($total_time/60)) minutes"
  else
    total_time="${total_time} seconds"
  fi

  # Print success msg
  make_banner "✨ Dotfiles configured successfully in $total_time" ${GREEN_B} 1

  # Show notification if available
  if command_exists notify-send; then
    notify-send -u normal -t 15000 "${TITLE}" "All tasks complete"
  fi

  # Refresh ZSH session
  SKIP_WELCOME=true || exec zsh

  # Show press any key to exit
  echo -e "${CYAN_B}Press any key to exit.${RESET}\n"
  read -t $PROMPT_TIMEOUT -n 1 -s

  exit 0
}

# Trigger cleanup on exit
trap cleanup EXIT

# If --help flag passed in, just show the help menu
if [[ $PARAMS == *"--help"* ]]; then
  make_intro
  exit 0
fi

# Let's Begin!
pre_setup_tasks   # Print start message, and check requirements are met
setup_dot_files   # Clone / update dotfiles, and create the symlinks
install_packages  # Prompt to install / update packages
apply_preferences # Apply settings for ZSH and desktop
finishing_up      # Refresh current session, print summary and exit
# All done :)
