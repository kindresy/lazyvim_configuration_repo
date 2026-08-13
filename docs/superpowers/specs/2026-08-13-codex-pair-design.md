# LazyVim 双 Codex 终端设计

## 目标

在 LazyVim 中通过一个快捷键打开两个相互独立、可持续复用的 Codex CLI 会话，同时保留现有普通终端快捷键。

## 交互

- `<leader>ac` 首次调用时，使用当前项目根目录作为工作目录，在编辑区右侧创建一个约占窗口 40% 宽度的区域。
- 该区域包含上下两个等高的内置终端；每个终端各运行一个 `codex` 进程。
- 后续调用 `<leader>ac` 不创建新进程：若两个会话的缓冲区仍有效，则重新展示该布局并聚焦上方会话。
- `<leader>rt` 保持不变，继续打开现有的 ToggleTerm 普通终端。

## 实现边界

在 `lua/config/keymaps.lua` 增加一个小型 Lua 会话管理器，而不改变 `toggleterm.nvim` 的全局布局设置。管理器保存两个 terminal buffer 的引用，使用 LazyVim 的项目根目录（不可用时回退到 Neovim 当前工作目录）启动 `codex`，并在缓冲区失效后按需重新创建。

## 错误处理

若 `codex` 命令不存在，终端保留 shell 报出的错误信息；不会影响 LazyVim 启动或其他快捷键。若一个会话退出，下一次调用快捷键只重新创建已失效的会话。

## 验证

使用无界面 Neovim 加载配置并检查 Lua 语法；再以 Neovim API 加载键位配置，确认 `<leader>ac` 已注册且不会破坏原有 `<leader>rt`。
