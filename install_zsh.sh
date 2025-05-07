#!/usr/bin/env bash

# ZSH Installer with Theme Selector
# Version 1.0
# Author: Abhishek Kumar
# Description: Installs zsh, allows theme selection, and sets as default shell

# Exit immediately if a command fails
set -e

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

# Fun Terminal ASCII Art
echo -e "${YELLOW}"
cat << "EOF"
  ╔════════════════════════════╗
  ║                            ║
  ║    Let's pimp your shell!  ║
  ║                            ║
  ╚════════════════════════════╝
   \   ^__^
    \  (oo)\_______
       (__)\       )\/\
           ||----w |
           ||     ||
EOF
echo -e "${NC}"

# Functions
header() {
    echo -e "${CYAN}==> $1${NC}"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Security checks
if [[ $EUID -eq 0 || -n "$SUDO_USER" ]]; then
    echo -e "${RED}Error: Run as normal user, not root/sudo${NC}"
    exit 1
fi

# Install zsh if needed
if ! command_exists zsh; then
    header "Installing ZSH"
    if command_exists apt; then sudo apt install -y zsh
    elif command_exists dnf; then sudo dnf install -y zsh
    elif command_exists yum; then sudo yum install -y zsh
    elif command_exists pacman; then sudo pacman -Sy --noconfirm zsh
    elif command_exists brew; then brew install zsh
    else echo -e "${RED}No package manager found!${NC}"; exit 1
    fi
else
    echo -e "${GREEN}✓ ZSH already installed${NC}"
fi

# Install Oh My Zsh
OMZ_DIR="${HOME}/.oh-my-zsh"
if [[ ! -d "$OMZ_DIR" ]]; then
    header "Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${GREEN}✓ Oh My Zsh already installed${NC}"
fi

# Theme selection
header "Select Theme"
echo "1. Agnoster (default)"
echo "2. Powerlevel10k"
echo "3. Spaceship"
echo "4. Robbyrussell"
echo "5. Afowler"
echo "6. Fishy"

read -rp "Choice [1-6]: " theme_choice

case $theme_choice in
    1|"") theme="agnoster" ;;
    2) theme="powerlevel10k/powerlevel10k"
       [[ ! -d "${OMZ_DIR}/custom/themes/powerlevel10k" ]] && 
       git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${OMZ_DIR}/custom/themes/powerlevel10k" ;;
    3) theme="spaceship"
       [[ ! -d "${OMZ_DIR}/custom/themes/spaceship-prompt" ]] && {
       git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "${OMZ_DIR}/custom/themes/spaceship-prompt"
       ln -s "${OMZ_DIR}/custom/themes/spaceship-prompt/spaceship.zsh-theme" "${OMZ_DIR}/custom/themes/spaceship.zsh-theme"; } ;;
    4) theme="robbyrussell" ;;
    5) theme="afowler" ;;
    6) theme="fishy" ;;
    *) echo -e "${RED}Invalid choice, using Agnoster${NC}"; theme="agnoster" ;;
esac

# Clean backup system
ZSH_RC="${HOME}/.zshrc"
BACKUP="${HOME}/.zshrc.backup"

header "Configuring ZSH"
if [[ -f "$ZSH_RC" ]]; then
    cp "$ZSH_RC" "$BACKUP"
    echo -e "${YELLOW}Backup saved to ${BACKUP}${NC}"
fi

# Set theme (using @ as delimiter for safety)
if grep -q "^ZSH_THEME=" "$ZSH_RC" 2>/dev/null; then
    sed -i.tmp "s@^ZSH_THEME=.*@ZSH_THEME=\"${theme}\"@" "$ZSH_RC" && rm -f "$ZSH_RC.tmp"
else
    echo "ZSH_THEME=\"${theme}\"" >> "$ZSH_RC"
fi

# Set default shell
if [[ "$(basename "$SHELL")" != "zsh" ]]; then
    header "Setting ZSH as default"
    if sudo chsh -s "$(which zsh)" "$USER"; then
        echo -e "${GREEN}✓ Default shell changed${NC}"
    else
        echo -e "${YELLOW}Couldn't change shell automatically"
        echo -e "Run manually: chsh -s $(which zsh)${NC}"
    fi
else
    echo -e "${GREEN}✓ ZSH already default shell${NC}"
fi

# Completion
echo -e "\n${GREEN}Installation complete!${NC}"
echo -e "New theme: ${CYAN}${theme}${NC}"
echo -e "\nRestart your terminal or run: ${BOLD}exec zsh${NORMAL}"

if [[ "$theme" == "powerlevel10k/powerlevel10k" ]]; then
    echo -e "\n${YELLOW}After restart, configure Powerlevel10k with: p10k configure${NC}"
fi
