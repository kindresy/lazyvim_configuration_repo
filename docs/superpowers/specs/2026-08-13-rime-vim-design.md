# rime.vim for LazyVim Design

## Goal

Install `TSalmon3/rime.vim` into the local LazyVim configuration and make Chinese input usable on Ubuntu, including its native backend, a current Lua-enabled librime, and a dedicated Rime Ice data directory.

## Design

- Install the Ubuntu development packages required to compile librime, librime-lua, and the plugin backend.
- Build the stable librime `1.17.0` release with `hchunhui/librime-lua` and install it under `/usr/local`; build glog `0.7.1` there as well because Ubuntu 22.04's glog lacks the API required by this librime release. Run `ldconfig` so the plugin backend resolves those libraries instead of Ubuntu's older packages.
- Add a self-contained Lazy plugin spec at `lua/plugins/rime.lua`.
- Install the pinned `rime.vim` source snapshot under `~/.local/share/nvim/local/rime.vim`; point Lazy at this local source and build `cpp/build/rime-query` with Clang and CMake. This avoids the host's unreliable Git pack transfer while retaining the upstream URL as metadata.
- Extract the official Rime Ice `2026.06.30` full release into `~/.local/share/rime-nvim`, keeping Neovim's user database separate from system input methods and other editors.
- Set all `g:im_*` variables in the plugin spec's `init` callback so they exist before the Vim plugin loads.
- Prepend the backend directory to Neovim's process `PATH`, because the upstream startup guard checks `executable('rime-query')` before launching the configured absolute path.
- Keep the plugin's default full-Pinyin schema and default `;;` toggle mapping.
- Write backend logs under `~/.local/state/nvim/rime.log`.

## Failure Handling

- Package, clone, or build failures stop the installation and are reported without changing unrelated LazyVim files.
- The system-wide source install is limited to `/usr/local`; Ubuntu-managed files under `/usr` are not overwritten.
- Existing user changes in the LazyVim repository are preserved.
- If headless backend startup fails, inspect the plugin log and dynamic-library resolution before changing configuration.

## Verification

- Format and syntax-check the new Lua plugin spec.
- Confirm Lazy recognizes the local `rime.vim` plugin.
- Confirm `rime-query` exists and links to `librime`.
- Confirm the installed librime reports version `1.17.0` and exposes the Lua plugin module.
- Send `nihao` to the backend and confirm the active `rime_ice` schema returns `你好`.
- Start Neovim headlessly and confirm `:IMStart`, `:IMStop`, and `:IMToggle` are registered.
- Start and stop the backend headlessly and check for errors.
