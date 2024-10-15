#!/bin/bash
# vim: ai:ts=4:sw=4:noet
# Install SH development environment
# Supports MacOS and Arch Linux

echo "Installing Neovim's dependencies..."
echo ""

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	# Linux
	distribution=$(grep '^NAME' /etc/os-release)
	case $distribution in
	NAME="Arch Linux")
		pacman -S python3
		pacman -S gnu-sed
		pacman -S fd
		pacman -S ripgrep
		pacman -S luajit
		pacman -S tree-sitter
		pacman -S neovim
		pacman -S node
		pacman -S bat
		;;
	*)
		echo "Your Linux distribution is not supported by the installer at this moment."
		exit 1
		;;
	esac

	# Generic installs for Linux
	curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz
	tar -zxf lua-5.3.5.tar.gz
	cd lua-5.3.5 || exit
	sudo make install
	cd ..
	sudo rm -r lua-5.3.5

elif [[ "$OSTYPE" == "darwin"* ]]; then
	# MacOS
	architecture=$(uname -m)
	case $architecture in
	# Mac Intel silicon
	x86_64)
		brew install python3
		brew install gnu-sed
		brew install fd
		brew install ripgrep
		brew install luajit
		brew install tree-sitter
		brew install neovim --HEAD
		brew install luarocks
		brew install node@16
		brew install bat
		;;

	# Mac Apple silicon
	arm64)
		arch -arm64 brew install python3
		arch -arm64 brew install gnu-sed
		arch -arm64 brew install fd
		arch -arm64 brew install ripgrep
		arch -arm64 brew install --HEAD luajit
		arch -arm64 brew install tree-sitter
		arch -arm64 brew install neovim --HEAD
		arch -arm64 brew install luarocks
		arch -arm64 brew install node@16
		arch -arm64 brew install bat
		;;
	esac
else
	echo "Your OS is not supported by the installer at this moment."
	exit 1
fi

# Generic installs for all OS's
npm install -g neovim

# Create nvim conda env
conda create -n nvim python
conda activate nvim
pip install --upgrade pip
pip install pynvim jupyter jupyter_client jupytext Pillow cairosvg pnglatex plotly kaleido ipykernel pylatexenc keyring tornado requests
pip install \
	--global-option=build_ext \
	--global-option="-I/usr/local/include" \
	--global-option="-L/opt/X11/lib" \
	lookatme.contrib.image_ueberzug
conda deactivate

sudo mv ~/.config/nvim ~/.config/nvim.old
mkdir ~/.config
mkdir ~/.config/nvim
cp -r ./*glob* ~/.config/nvim

echo ""
echo "Done! Neovim has been configured. Use the command \"nvim\" to start using it."
