return {
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000",
        render = "wrapped-compact",
        max_width = 50, -- Adjust this number to your preference
      })

      vim.notify = require("notify")
    end,
    event = "VeryLazy",
  },
  { 'wakatime/vim-wakatime', lazy = false },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = true })
        end,
        desc = "Local Keymaps",
      },
    },
  },
  {
    "gbprod/yanky.nvim",
    dependencies = {
      { "kkharji/sqlite.lua" }
    },
    event = "VeryLazy",
    opts = {
      ring = { storage = "sqlite" },
    },
    keys = {
      { "<leader>p", "<cmd>Telescope yank_history<cr>",        mode = { "n", "x" },                                desc = "Open Yank History" },
      { "y",         "<Plug>(YankyYank)",                      mode = { "n", "x" },                                desc = "Yank text" },
      { "p",         "<Plug>(YankyPutAfter)",                  mode = { "n", "x" },                                desc = "Put yanked text after cursor" },
      { "P",         "<Plug>(YankyPutBefore)",                 mode = { "n", "x" },                                desc = "Put yanked text before cursor" },
      { "gp",        "<Plug>(YankyGPutAfter)",                 mode = { "n", "x" },                                desc = "Put yanked text after selection" },
      { "gP",        "<Plug>(YankyGPutBefore)",                mode = { "n", "x" },                                desc = "Put yanked text before selection" },
      { "<c-p>",     "<Plug>(YankyPreviousEntry)",             desc = "Select previous entry through yank history" },
      { "<c-n>",     "<Plug>(YankyNextEntry)",                 desc = "Select next entry through yank history" },
      { "]p",        "<Plug>(YankyPutIndentAfterLinewise)",    desc = "Put indented after cursor (linewise)" },
      { "[p",        "<Plug>(YankyPutIndentBeforeLinewise)",   desc = "Put indented before cursor (linewise)" },
      { "]P",        "<Plug>(YankyPutIndentAfterLinewise)",    desc = "Put indented after cursor (linewise)" },
      { "[P",        "<Plug>(YankyPutIndentBeforeLinewise)",   desc = "Put indented before cursor (linewise)" },
      { ">p",        "<Plug>(YankyPutIndentAfterShiftRight)",  desc = "Put and indent right" },
      { "<p",        "<Plug>(YankyPutIndentAfterShiftLeft)",   desc = "Put and indent left" },
      { ">P",        "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
      { "<P",        "<Plug>(YankyPutIndentBeforeShiftLeft)",  desc = "Put before and indent left" },
      { "=p",        "<Plug>(YankyPutAfterFilter)",            desc = "Put after applying a filter" },
      { "=P",        "<Plug>(YankyPutBeforeFilter)",           desc = "Put before applying a filter" },
    },
  }
}
