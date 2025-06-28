# My Neovim config

This is my current Neovim configuration. This is not a generic or customization oriented config: my current focus is on machine learning research on `Python` and `Quarto`, using tools like virtual environments, and web development (`Go`, `Next.js`, `TypeScript`, `TailwindCSS`, etc.). There is built-in support for many other languages, but you need to investigate yourself. Nonetheless, hopefully it is easy to tweak for other purposes.

## Performance

I'm using a lot of plugins (+100!). This can be scary as it generally correlates to poor performance, and performance is a top reason why a lot of people use n/vim. However, this config runs at a fair speed thanks, mostly, to lazy loading: most plugins are only loaded when used via their commands or on specific events. I am dropping a personally acceptable amount of performance for great functionality gains, which in my view and for my use cases is worth it.

Startup times vary depending on the file type. In particular, `markdown` and `quarto` files take some 100 ms more to load due to fancy rendering. Performance when editing and navigating files is generally very good, with minimal input lag differences compared to vanilla Neovim.

## Installer

You can install this config by cloning the repo and performing `make install` from root. The installer has been tested on MacOS, other systems may not work. In any case, if you encounter issues running it, you can always simply run each line of the script `scripts/install.sh` in your shell; there, you can see all steps and tools necessary for this config to work well, and you can install them in a way that works for your system. It is also highly recommended to install a [nerdfont](https://www.nerdfonts.com/) of your choice.

## Tips

To connect to a remote file-system via SSH:
1. Use `ssh-add` to add the private key you use to identify with the server.
2. Start Neovim as `nvim oil-ssh://<user>@<ip>:<port>/`

## Acknowledgments

This config is just the work of the Neovim team and contributors, as well as the developers who contribute to the Neovim plugin ecosystem, glued together in a certain way. Much appreciation for this community!

Initially when starting to write this config, I took as reference boilerplate code from many open source configs out there in order to develop different parts and features. These include (but are not limited to):

- [LunarVim](https://github.com/LunarVim/LunarVim)
- [NvChad](https://github.com/NvChad/NvChad)
- EdenEast's [config](https://github.com/EdenEast/nyx/tree/8a9819e4ea11193434b2366b9f1d65ed3a4661f3/config/.config/nvim)
