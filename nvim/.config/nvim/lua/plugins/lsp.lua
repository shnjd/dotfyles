return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    commit = "b356f2c",
    pin = true,
    event = "InsertEnter",
    dependencies = {
      'hrsh7th/vim-vsnip',
      'hrsh7th/vim-vsnip-integ',
      -- LSP source
      "hrsh7th/cmp-nvim-lsp",
      -- Buffer completions
      "hrsh7th/cmp-buffer",
      -- Path completions
      "hrsh7th/cmp-path",
      -- Lua API completions
      "hrsh7th/cmp-nvim-lua",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          {
            name = "nvim_lsp",
            entry_filter = function(entry)
              -- Filter out snippet completions from LSP
              return entry:get_kind() ~= require("cmp.types").lsp.CompletionItemKind.Snippet
            end,
          },
          { name = 'vsnip' }, -- For vsnip users.
          { name = "buffer" },
          { name = "path" },
          { name = "nvim_lua" },
        }),
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              vsnip    = "[Snip]",
              buffer   = "[Buf]",
              path     = "[Path]",
              nvim_lua = "[Lua]",
            })[entry.source.name]
            return vim_item
          end,
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "typescript", "json", "markdown"
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    opts = {
      enable_autocmd = false
    }
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
    }
  }
}
