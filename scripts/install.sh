#!/bin/bash
# vim: ai:ts=4:sw=4:noet
# Install SH development environment
# Supports MacOS and Arch Linux

echo "Welcome to my Neovim config installer! Which Python environment tool do you use? Answer either 'conda', 'micromamba', or 'mamba'"
read -r python_tool
while [[ "$python_tool" != "conda" ]] && [[ "$python_tool" != "mamba" ]] && [["$python_tool" != "micromamba"]]; do
	echo "Please answer either 'conda', 'micromamba', or 'mamba'"
	read -r python_tool
done

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
		pacman -S wordnet
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
	brew install wordnet
else
	echo "Your OS is not supported by the installer at this moment."
	exit 1
fi

# Generic installs for all OS's
npm install -g neovim

# Create nvim mamba (conda) env
if [[ "$python_tool" == "micromamba" ]]; then
	micromamba create -n nvim python
	micromamba activate nvim
else
	echo "Your python environment tool is not integrated at the moment, please open an issue"
fi
pip install --upgrade pip
pip install pynvim jupyter jupyter_client jupytext Pillow cairosvg pnglatex plotly kaleido ipykernel pylatexenc keyring tornado requests
pip install \
	--global-option=build_ext \
	--global-option="-I/usr/local/include" \
	--global-option="-L/opt/X11/lib" \
	lookatme.contrib.image_ueberzug
if [[ "$python_tool" == "micromamba" ]]; then
	micromamba activate base
else
	echo "Your python environment tool is not integrated at the moment, please open an issue"
fi

[[ -d ~/.config ]] || mkdir ~/.config
[[ -d ~/.config/nvim ]] || sudo mv ~/.config/nvim ~/.config/nvim.old
mkdir ~/.config/nvim
cp -r ./*glob* ~/.config/nvim

echo ""
echo "Done! Neovim has been configured. Use the command \"nvim\" to start using it."
