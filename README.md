# My Neovim config

This is my current `nvim` configuration. This is not a generic or customization oriented config: my current focus is on web development (`Go`, `Vue`, `TypeScript`, `TailwindCSS`, etc.), machine learning on `Python` and also some `C/C++`, hence this config will be adapted mostly to that. Nonetheless, it is hopefully easy to tweak for other purposes.

## Examples of features

<details markdown='1'>
    <summary>Completion</summary>
    <img src="assets/media/completion.png" alt="Completion">
</details>

<details markdown='1'>
    <summary>Diagnostics</summary>
    <img src="assets/media/diagnostics.png" alt="Diagnostics">
</details>

<details markdown='1'>
    <summary>Searching files, words, etc.</summary>
    <img src="assets/media/telescope.png" alt="Searching">
</details>

<details markdown='1'>
    <summary>Search and replace</summary>
    <img src="assets/media/spectre.png" alt="Search and replace">
</details>

<details markdown='1'>
    <summary>Git diff</summary>
    <img src="assets/media/gitdiff.png" alt="Git diff">
</details>

## Performance

I'm using a lot of plugins (+100!). This can be scary as it generally correlates to poor performance, and performance is a top reason why a lot of people use n/vim. However, this config runs at a fair speed thanks, mostly, to lazy loading: most plugins are only loaded when used via their commands or on specific events. I am dropping a personally acceptable amount of performance for great functionality gains, which in my view and for my use cases is worth it.

After performing some startup time tests, these are the results obtained in an M1 Pro 2021 MacBook Pro (note that there will be variance in your experiences, based on a variety of factors):

- Starting up nvim without opening a file: `~75 ms`
- Starting up nvim opening a ~100 lines file: `~135 ms`

There is still a lot of room for improvement on this front, as there are still many plugins not optimized via lazy loading (e.g., DAP plugins) and some other optimizations can also be applied.

## TODO

- [x] Remove `lspsaga` and `dressing.nvim` and configure custom UI.
- [ ] Remove the line wrapping symbol in .txt, .md and other types of text files.
- [ ] Add configuration to support jupyter notebooks; perhaps write own plugin when [anticonceal](https://github.com/neovim/neovim/pull/9496) and [native support for Kitty's graphic protocol](https://github.com/neovim/neovim/issues/12991) are merged.

## Acknowledgments

First of all, thanks to the `Neovim` team and contributors, as well as the developers who contribute to the nvim plugin ecosystem. After all, this config is just their work glued together in a certain way.

I took as reference many open source configs and pieces of code out there in order to develop different parts and features of this config. These include (but are not limited to):

- [LunarVim](https://github.com/LunarVim/LunarVim)
- [NvChad](https://github.com/NvChad/NvChad)
- EdenEast's [config](https://github.com/EdenEast/nyx/tree/8a9819e4ea11193434b2366b9f1d65ed3a4661f3/config/.config/nvim)
