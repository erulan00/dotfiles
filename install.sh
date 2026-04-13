sudo apt update
# pre install
sudo apt install -y stow

sudo apt install -y \
guake \

# Guake settings
stow guake
guake --restore-preferences ~/dotfiles/guake/guake-settings