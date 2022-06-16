#!/bin/bash
# vim: ai:ts=4:sw=4:noet
# Install SH development environment
# Supports MacOS and Arch Linux

echo "Starting to install all dependencies..."
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
			pacman -S isort
			pacman -S clang-format
			pacman -S cppcheck
			pacman -S python-pylint
			pacman -S golangci-lint
			pacman -S node
			pacman -S lazygit
            ;;
        *)
            echo "Your Linux distribution is not supported by the installer at this moment."
            exit 1
            ;;
    esac

	curl https://sh.rustup.rs -sSf | sh
	cargo install stylua

	curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz
	tar -zxf lua-5.3.5.tar.gz
	cd lua-5.3.5
	sudo make install
	cd ..
	sudo rm -r lua-5.3.5

	luarocks install luacheck

	python3 -m pip install --upgrade pip
	python3 -m pip install --user --upgrade pynvim
	python3 -m pip install cmakelang

	go install golang.org/x/tools/cmd/goimports@latest

	npm install -g neovim
	npm install -g eslint
	npm install -g eslint_d
	npm install -g prettier
	npm install -g @fsouza/prettierd
	npm install -g jsonlint
	npm install -g markdownlint
	npm install -g mprocs

elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    architecture=$(uname -m)
    case $architecture in
        # Intel silicon
        x86_64) 
			brew install python3
            brew install gnu-sed
			brew install fd
            brew install ripgrep
            brew install luajit
            brew install tree-sitter
            brew install neovim
			brew install luarocks
			brew install isort
			brew install clang-format
			brew install cppcheck
			brew install golangci-lint
			brew install node
			brew install jesseduffield/lazygit/lazygit
			brew install pvolok/mprocs/mprocs
            ;;

        # Apple silicon
        arm64) 
			arch -arm64 brew install python3
            arch -arm64 brew install gnu-sed
			arch -arm64 brew install fd
            arch -arm64 brew install ripgrep
            arch -arm64 brew install --HEAD luajit
            arch -arm64 brew install tree-sitter
            arch -arm64 brew install neovim
			arch -arm64 brew install luarocks
			arch -arm64 brew install isort
			arch -arm64 brew install clang-format
			arch -arm64 brew install cppcheck
			arch -arm64 brew install golangci-lint
			arch -arm64 brew install node
			arch -arm64 brew install jesseduffield/lazygit/lazygit
			arch -arm64 brew install pvolok/mprocs/mprocs
            ;;
    esac

	curl https://sh.rustup.rs -sSf | sh
	cargo install stylua

	luarocks install luacheck

	python3 -m pip install --upgrade pip
	python3 -m pip install --user --upgrade pynvim
	python3 -m pip install pylint
	python3 -m pip install cmakelang

	go install golang.org/x/tools/cmd/goimports@latest

	npm install -g neovim
	npm install -g eslint
	npm install -g eslint_d
	npm install -g prettier
	npm install -g @fsouza/prettierd
	npm install -g jsonlint
	npm install -g markdownlint

else
    echo "Your OS is not supported by the installer at this moment."
    exit 1
fi

git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

echo ""
echo "Done! All dependencies have been installed. Use the command \"nvim\" to start using Neovim."

