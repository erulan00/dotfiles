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

sleep
