# rime.vim for LazyVim Design

## Goal

Install `TSalmon3/rime.vim` into the local LazyVim configuration and make Chinese input usable on Ubuntu, including its native backend, a current Lua-enabled librime, and a dedicated Rime Ice data directory.

## Design

- Install the Ubuntu development packages required to compile librime, librime-lua, and the plugin backend.
- Build the stable librime `1.16.1` release with `hchunhui/librime-lua` and install it under `/usr/local`; run `ldconfig` so the plugin backend resolves that library instead of Ubuntu 22.04's unsupported librime `1.7.3`.
- Add a self-contained Lazy plugin spec at `lua/plugins/rime.lua`.
- Let `lazy.nvim` clone the plugin and build `cpp/build/rime-query` with CMake.
- Clone the current Rime Ice configuration into `~/.local/share/rime-nvim`, keeping Neovim's user database separate from system input methods and other editors.
- Set all `g:im_*` variables in the plugin spec's `init` callback so they exist before the Vim plugin loads.
- Keep the plugin's default full-Pinyin schema and default `;;` toggle mapping.
- Write backend logs under `~/.local/state/nvim/rime.log`.

## Failure Handling

- Package, clone, or build failures stop the installation and are reported without changing unrelated LazyVim files.
- The system-wide source install is limited to `/usr/local`; Ubuntu-managed files under `/usr` are not overwritten.
- Existing user changes in the LazyVim repository are preserved.
- If headless backend startup fails, inspect the plugin log and dynamic-library resolution before changing configuration.

## Verification

- Format and syntax-check the new Lua plugin spec.
- Run Lazy sync/install for `rime.vim`.
- Confirm `rime-query` exists and links to `librime`.
- Confirm the installed librime reports version `1.16.1` and exposes the Lua plugin module.
- Start Neovim headlessly and confirm `:IMStart`, `:IMStop`, and `:IMToggle` are registered.
- Start and stop the backend headlessly and check for errors.
