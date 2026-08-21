local root = vim.fn.getcwd()
local specs = dofile(root .. "/lua/plugins/markdown_prev.lua")
local plugins = {}

for _, spec in ipairs(specs) do
  plugins[spec[1]] = spec
end

assert(plugins["ellisonleao/glow.nvim"] == nil, "obsolete glow.nvim spec is still present")

local render = assert(plugins["MeanderingProgrammer/render-markdown.nvim"], "render-markdown.nvim spec is missing")
assert(vim.tbl_contains(render.ft, "markdown"), "render-markdown.nvim is not lazy-loaded for Markdown")
assert(render.opts.preset == "lazy", "render-markdown.nvim does not use the LazyVim preset")

local toggle
for _, mapping in ipairs(render.keys or {}) do
  if mapping[1] == "<leader>um" then
    toggle = mapping
    break
  end
end
assert(toggle, "<leader>um Markdown rendering toggle is missing")

local image = assert(plugins["3rd/image.nvim"], "image.nvim spec is missing")
assert(image.build == false, "image.nvim must not build the LuaRock processor")
assert(image.opts.backend == "kitty", "image.nvim does not use the Kitty backend")
assert(image.opts.processor == "magick_cli", "image.nvim does not use ImageMagick CLI")

local markdown = image.opts.integrations.markdown
assert(markdown.enabled, "image.nvim Markdown integration is disabled")
assert(markdown.clear_in_insert_mode, "images must clear while editing")
assert(not markdown.download_remote_images, "remote Markdown images must not download automatically")
assert(markdown.only_render_image_at_cursor, "image rendering is not limited to the cursor")
assert(markdown.only_render_image_at_cursor_mode == "inline", "cursor image mode is not inline")
assert(not image.opts.integrations.asciidoc.enabled, "unrequested AsciiDoc integration is enabled")
assert(not image.opts.integrations.neorg.enabled, "unrequested Neorg integration is enabled")
assert(not image.opts.integrations.rst.enabled, "unrequested RST integration is enabled")
assert(not image.opts.integrations.typst.enabled, "unrequested Typst integration is enabled")
assert(not image.opts.integrations.html.enabled, "unrequested HTML integration is enabled")
assert(not image.opts.integrations.css.enabled, "unrequested CSS integration is enabled")

vim.g.mkdp_preview_options = nil
vim.g.mkdp_page_title = nil
vim.g.mkdp_theme = nil
dofile(root .. "/lua/config/options.lua")()
assert(vim.g.mkdp_preview_options == nil, "obsolete mkdp preview options are still configured")
assert(vim.g.mkdp_page_title == nil, "obsolete mkdp page title is still configured")
assert(vim.g.mkdp_theme == nil, "obsolete mkdp theme is still configured")
