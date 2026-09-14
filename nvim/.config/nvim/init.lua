require("config.base")
require("config.lazy")
require("config.keymaps")

-- NOTE: To be removed, temporary fix for the markdown error
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.treesitter.stop()
  end,
})
