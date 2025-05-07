# One-Click ZSH Installer & Customizer

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) 
[![Shell Check](https://img.shields.io/badge/ShellCheck-Validated-brightgreen)](https://github.com/koalaman/shellcheck)
![Tested On](https://img.shields.io/badge/Tested%20On-Ubuntu%20|%20Fedora%20|%20Arch-blueviolet)

The ultimate all-in-one solution to install ZSH and configure it beautifully in a single command! ✨

## 🔥 Features

### 🛠️ Installation
- **One-command ZSH installation** (auto-detects your package manager)
- **Oh My ZSH auto-setup** (with unattended installation)
- **Default shell configuration** (no manual `chsh` needed)

### 🎨 Customization Suite
- **Interactive theme selector**
- **Backup system** (keeps your original config safe)
- **Special themes included**:
  - Powerlevel10k (blazing fast prompt)
  - Spaceship (modern git-aware design)
  - Agnoster (classic powerline style)
  - Robbyrussell (default OMZ theme)

## 🚀 Installation

```bash
# For the impatient (direct pipe to bash):
curl -fsSL https://raw.githubusercontent.com/hellofuji/zsh-installer/main/install_zsh.sh | bash

# For the cautious (download first):
wget https://raw.githubusercontent.com/hellofuji/zsh-installer/main/install_zsh.sh
chmod +x install.sh
./install.sh
