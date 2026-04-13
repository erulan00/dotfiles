# !/bin/bash

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

# i3 settings
stow i3

# install homebrew
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    sudo apt install -y build-essential
fi

# install warp(or download .deb and install it)
if ! command -v warp-terminal &> /dev/null; then
    echo "Warp not found. Installing Warp..."
    sudo sh -c "echo -e '\n[warpdotdev]\nServer = https://releases.warp.dev/linux/pacman/\$repo/\$arch' >> /etc/pacman.conf"
    sudo pacman-key -r "linux-maintainers@warp.dev"
    sudo pacman-key --lsign-key "linux-maintainers@warp.dev"
    sudo pacman -Sy warp-terminal
fi

sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/warp-terminal 50
sudo update-alternatives --config x-terminal-emulator

sleep
