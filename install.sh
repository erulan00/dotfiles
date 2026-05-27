#!/usr/bin/env bash
set -euo pipefail

# register GPG key
# regolith
# 1. Register the Regolith public key to your local apt
wget -qO - https://archive.regolith-desktop.com/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

# 2. Add the repository URL to your local apt:
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://archive.regolith-desktop.com/ubuntu/stable noble v3.4" | \
sudo tee /etc/apt/sources.list.d/regolith.list

# install packages
sudo apt update
sudo apt install -y \
    stow \
    ibus-mozc \
    regolith-desktop \
    regolith-session-flashback \
    regolith-look-lascaille \
    xdg-desktop-portal-regolith \
    rclone \
    tree \
    playerctl \
    jq \
    curl \
    imagemagick \
    khal \
    fonts-jetbrains-mono

# i3 settings
stow i3

# rclone settings
stow -v rclone

# eww lockscreen settings and helper scripts
mkdir -p "$HOME/.config" "$HOME/.local"
stow -v -t "$HOME/.config" .config
stow -v -t "$HOME/.local" .local

systemctl --user daemon-reload
systemctl --user start rclone-mount.service
systemctl --user enable rclone-mount.service
systemctl --user start rclone-sync.timer
systemctl --user enable rclone-sync.timer

# install homebrew
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    sudo apt install -y build-essential
fi

# install warp(or download .deb and install it)
if ! command -v warp-terminal &> /dev/null; then
    if command -v pacman &> /dev/null; then
        echo "Warp not found. Installing Warp with pacman..."
        sudo sh -c "echo -e '\n[warpdotdev]\nServer = https://releases.warp.dev/linux/pacman/\$repo/\$arch' >> /etc/pacman.conf"
        sudo pacman-key -r "linux-maintainers@warp.dev"
        sudo pacman-key --lsign-key "linux-maintainers@warp.dev"
        sudo pacman -Sy warp-terminal
    else
        echo "Warp not found. Download and install the Ubuntu .deb package manually."
    fi
fi

# set warp as default terminal emulator
if command -v warp-terminal &> /dev/null; then
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/warp-terminal 50
    sudo update-alternatives --config x-terminal-emulator
fi

missing_commands=()
for command_name in eww i3lock-color; do
    if ! command -v "$command_name" &> /dev/null; then
        missing_commands+=("$command_name")
    fi
done

if [ "${#missing_commands[@]}" -gt 0 ]; then
    echo "Install these manually for the EWW lockscreen: ${missing_commands[*]}"
fi
