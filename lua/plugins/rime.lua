local plugin_dir = vim.fn.stdpath("data") .. "/local/rime.vim"

return {
  {
    dir = plugin_dir,
    name = "rime.vim",
    url = "https://github.com/TSalmon3/rime.vim",
    build = "CXX=clang++ cmake -S cpp -B cpp/build && cmake --build cpp/build -j2",
    init = function()
      local backend_dir = plugin_dir .. "/cpp/build"
      local rime_dir = vim.fn.expand("~/.local/share/rime-nvim")
      local log_file = vim.fn.expand("~/.local/state/nvim/rime.log")

      vim.fn.mkdir(vim.fn.fnamemodify(log_file, ":h"), "p")
      vim.env.PATH = backend_dir .. ":" .. vim.env.PATH
      vim.g.im_rime_bin = backend_dir .. "/rime-query"
      vim.g.im_user_data_dir = rime_dir
      vim.g.im_shared_data_dir = rime_dir
      vim.g.im_log_file = log_file
      vim.g.im_toggle_key = ";;"
    end,
  },
}
