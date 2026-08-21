# LazyVim 内联 Markdown 与图片渲染设计

## 目标

在当前 Neovim 编辑窗口中直接渲染 Markdown，并尽可能在通过 SSH 连接的 WezTerm 中显示 Markdown 引用的本地图片。图片后端不可用时，Markdown 文字渲染仍须正常工作。

## 当前状态

- 当前配置包含 `glow.nvim`，但 `glow_path` 和 `install_path` 写死为无效的 `/snap/bin/glow`。
- 可用的 Glow 实际位于 `~/.local/bin/glow`，但 Glow 使用独立浮窗，不符合当前窗口内渲染的主要需求。
- `options.lua` 中包含未被现有插件使用的 `mkdp_*` 浏览器预览选项。
- 当前 Neovim 版本为 0.12 开发版，满足 `render-markdown.nvim` 的版本要求。
- 会话通过 SSH 运行，客户端使用 WezTerm；服务端存在 ImageMagick CLI。

## 方案

### Markdown 文字渲染

使用 `MeanderingProgrammer/render-markdown.nvim` 渲染标题、表格、代码块、列表、引用、链接和复选框。插件仅针对 Markdown 文件延迟加载，并沿用 LazyVim 风格的配置。

普通模式下默认显示渲染结果。插入模式下显示便于编辑的原始 Markdown。`<leader>um` 用于切换全局渲染状态。

### 图片渲染

使用 `3rd/image.nvim` 的 Markdown 集成解析图片引用：

- 后端使用 `kitty`，通过 WezTerm 实现的 Kitty Graphics Protocol 输出图片。
- 图片处理器使用 `magick_cli`，复用系统已有的 ImageMagick，避免引入 LuaRock 依赖。
- 仅渲染光标所在图片引用对应的图片，并使用 inline 显示模式，以降低 SSH 下的刷新开销和残影概率。
- 支持相对于 Markdown 文档路径的本地图片。
- 禁止自动下载远程图片，避免打开文档时产生隐式网络访问。
- 不启用与本需求无关的 AsciiDoc、Neorg、RST、Typst、HTML 和 CSS 图片集成。

WezTerm 对 Kitty Graphics Protocol 的实现并非完全兼容，因此图片渲染属于尽力提供的增强能力。图片初始化或协议输出失败不得阻止 `render-markdown.nvim` 加载。

### 配置清理

用新的内联渲染配置替换现有 `lua/plugins/markdown_prev.lua` 中的 Glow 配置。删除 `options.lua` 中不再使用的 `mkdp_*` 浏览器预览选项，不保留重复的 Markdown 预览实现。

## 错误处理与降级

- `image.nvim` 与文字渲染保持为相互独立的插件规格，避免图片依赖故障破坏 Markdown 文字渲染。
- 如果终端协议、ImageMagick 或图片格式不受支持，用户仍可查看经过排版的 Markdown 和原始图片链接。
- 不通过配置自动安装系统软件；缺失依赖时保留可诊断的插件错误。

## 验证

自动验证包括：

1. Lua 配置语法正确且 LazyVim 可在 headless 模式启动。
2. 打开 Markdown 文件时能够加载 `render-markdown.nvim`。
3. `markdown` 与 `markdown_inline` Tree-sitter parser 可用。
4. `<leader>um` 映射存在且指向 Markdown 渲染开关。
5. `image.nvim` 配置采用 `kitty` 后端和 `magick_cli` 处理器。

图片是否真实显示无法在 headless 测试中确认。最终需要在用户的 WezTerm SSH 窗口内打开包含本地图片引用的 Markdown 文件进行人工验证。

## 非目标

- 浏览器实时预览。
- 自动下载远程 Markdown 图片。
- Mermaid、PlantUML 等图表渲染。
- 为 WezTerm、SSH 客户端或 Tmux 修改全局配置。
