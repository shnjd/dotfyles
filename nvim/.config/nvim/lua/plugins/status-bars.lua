-- lualine customization
local cp = require("catppuccin.palettes").get_palette("mocha")

-- stylua: ignore
local colors = {
  blue   = cp.sapphire,
  cyan   = cp.teal,
  black  = "#09090E",
  white  = cp.text,
  red    = cp.red,
  violet = cp.mauve,
  grey   = cp.surface0,
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.white, bg = "NONE" },
  },

  insert = { a = { fg = colors.black, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.white, bg = "NONE" },
  },
}

return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    options = {
      hover = {
        enabled = true,
        delay = 100,
        reveal = { 'close' }
      },
      diagnostics = "nvim_lsp"
    },
    dependencies = 'nvim-tree/nvim-web-devicons'
  },
  {
    'Bekaboo/dropbar.nvim',
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },
    config = function()
      local dropbar_api = require('dropbar.api')
      vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = bubbles_theme,
        component_separators = '',
        section_separators = { left = '', right = '' },
        globalstatus = true,
      },
      sections = {
        lualine_a = { { 'mode', separator = { left = '' }, right_padding = 1 } },
        lualine_b = { 'filename', 'branch' },
        lualine_c = { '%=' },
        lualine_x = {},
        lualine_y = { 'filetype', 'progress' },
        lualine_z = { { 'location', separator = { right = '' }, left_padding = 1 } },
      },
      inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'location' },
      },
      tabline = {},
      extensions = {},
    },
  }
}
