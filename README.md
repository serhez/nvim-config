# My Neovim config

This is my current nvim configuration. This is not a generic or customization oriented config: my current focus is on machine learning research on `Python`, using tools like `conda` environments and notebooks; web development (`Go`, `Vue`, `TypeScript`, `TailwindCSS`, etc.), and also some `C/C++`, hence this config will be adapted mostly to that. Nonetheless, it hopefully works out of the box or, at least, it is easy to tweak for other purposes.

## Performance

I'm using a lot of plugins (+100!). This can be scary as it generally correlates to poor performance, and performance is a top reason why a lot of people use n/vim. However, this config runs at a fair speed thanks, mostly, to lazy loading: most plugins are only loaded when used via their commands or on specific events. I am dropping a personally acceptable amount of performance for great functionality gains, which in my view and for my use cases is worth it.

After performing some startup time tests, these are the results obtained in an M1 Pro 2021 MacBook Pro (note that there will be variability in your experiences, based on a variety of factors):

- Startup screen (no session, no file): `~75 ms`
- Opening a `python` file (+loading a session): `~90 ms`
- Opening a `lua` file (+loading a session): `~95-115 ms`
- Opening a `markdown` file (+loading a session): `~170 ms`
- Opening a `quarto` file (+loading a session): `~180 ms`

Performance when editing and navigating files is generally very good, with minimal input lag differences compared to vanilla nvim. Whenever I notice a performance issue, I try to address it to achieve an unnoticeable difference to the vanilla editing experience.

## Acknowledgments

This config is just the work of the Neovim team and contributors, as well as the developers who contribute to the nvim plugin ecosystem, glued together in a certain way. Much appreciation for this community!

Initially when starting to write this config, I took as reference boilerplate code from many open source configs out there in order to develop different parts and features. These include (but are not limited to):

- [LunarVim](https://github.com/LunarVim/LunarVim)
- [NvChad](https://github.com/NvChad/NvChad)
- EdenEast's [config](https://github.com/EdenEast/nyx/tree/8a9819e4ea11193434b2366b9f1d65ed3a4661f3/config/.config/nvim)
