return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "markdown.mdx" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.icons",
    },
    keys = {
      {
        "<leader>um",
        function()
          require("render-markdown").toggle()
        end,
        desc = "Toggle Markdown Render",
        ft = "markdown",
      },
    },
    opts = {
      preset = "lazy",
      render_modes = { "n", "c", "t" },
      file_types = { "markdown", "markdown.mdx" },
    },
  },
  {
    "3rd/image.nvim",
    ft = { "markdown", "markdown.mdx" },
    build = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = false,
          only_render_image_at_cursor = true,
          only_render_image_at_cursor_mode = "inline",
          floating_windows = false,
          filetypes = { "markdown", "markdown.mdx" },
        },
        asciidoc = { enabled = false },
        neorg = { enabled = false },
        rst = { enabled = false },
        typst = { enabled = false },
        html = { enabled = false },
        css = { enabled = false },
      },
      max_height_window_percentage = 50,
      hijack_file_patterns = {},
    },
  },
}
