CONF_DIR=./configurations
BIN_DIR=$HOME/bin
PYTHON_FOLDER="python$(python -V | cut -d" " -f2 | awk -F"." '{print $1 "." $2 }')"
FONTS_DIR=$HOME/.fonts

mkdir $BIN_DIR

# ----- installing dependecies: -----
# this is for yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
# tmux >= 3.3a; zsh >= 5.9
sudo apt satisfy "tmux (>= 3.3a) zsh (>= 5.9)" -y
# following may fail:
sudo apt satisfy "nvim (>= 0.10.0)" -y
if (( $? != 0 )); then
    echo "manually install nvim from package:"
    sudo apt install $CONF_DIR/nvim-linux64.deb -y
fi

sudo apt install yarn nodejs npm clang ripgrep bat python3-pip git urlview -y

# installing brew and adding to path
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
cd $BIN_DIR
ln -s /home/linuxbrew/.linuxbrew/bin/brew

# remove externally managed python system. Needed to install packages with pip3
sudo mv /usr/lib/$PYTHON_FOLDER/EXTERNALLY-MANAGED /usr/lib/$PYTHON_FOLDER/EXTERNALLY-MANAGED.old

brew install fzf
pip3 install black
pip3 install --user pynvim

# ----- cloning repos -----
git clone https://github.com/ohmyzsh/ohmyzsh $HOME/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/gpakosz/.tmux $HOME/.tmux
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
git clone https://github.com/Blacksuan19/init.nvim $HOME/.config/nvim

# ----- moving dot.files and dot.folders -----
cp -r $CONF_DIR/.* $HOME
# set the correct position for init.vim
cp $CONF_DIR/init.vim .config/nvim/init.vim

# now tmux: <prefix> I. This is the command that executes it and install tpm plugins:
$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh

# ----- fonts -----
cd $FONTS_DIR
fc-cache -f -v

echo "\n\nAll done."
echo "Don't forget to set RobotoMono font in preferences of the terminal and run neovim to automatically install plugins."

