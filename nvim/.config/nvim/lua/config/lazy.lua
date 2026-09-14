local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.have_nerd_font = true

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "catppuccin" } },
  -- automatically check for plugin updates
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = false, -- get a notification when changes are found
  },
})

vim.cmd.colorscheme "catppuccin"

require("bufferline").setup {}

vim.filetype.get_option = function(filetype, option)
  return option == "commentstring"
      and require("ts_context_commentstring.internal").calculate_commentstring()
      or vim.filetype.get_option(filetype, option)
end

-- Define the server configuration using the new API template
vim.lsp.config('tailwindcss', {
  cmd = { 'tailwindcss-language-server', '--stdio' },
  filetypes = { 'aspnetcorerazor', 'astro', 'astro-markdown', 'blade', 'clojure', 'django', 'erb', 'eruby', 'ghtml', 'handlebars', 'hbs', 'html', 'htmlangular', 'htmlhtmldart', 'jade', 'jet', 'jinja', 'jinja2', 'jnlp', 'js', 'jsx', 'liquid', 'markdown', 'mdx', 'mustache', 'njk', 'nunjucks', 'php', 'play', 'razor', 'slim', 'twig', 'typescript', 'typescriptreact', 'vue', 'svelte' },
  root_markers = { 'tailwind.config.js', 'tailwind.config.ts', 'postcss.config.js', 'postcss.config.ts', 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
  settings = {
    tailwindCSS = {
      classFunctions = { "cva", "cx" },
    },
  },
})

-- Automatically start/attach the server based on filetype and root markers
vim.lsp.enable('tailwindcss')
