local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- refer for vim keybindings https://devhints.io/vim

-- Buffer navigation
map("n", "<leader>bn", ":bnext<CR>", opts)
map("n", "<leader>bv", ":bprevious<CR>", opts)
map("n", "<leader>bd", ":bd<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)

-- Windows
map("n", "<leader>ws", "<cmd>split<CR>", opts)
map("n", "<leader>wv", "<cmd>vsplit<CR>", opts)
map("n", "<C-Up>", "<cmd>resize -2<CR>", opts)
map("n", "<C-Down>", "<cmd>resize +2<CR>", opts)
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)
map("n", "<leader>w=", "<C-w>=", opts)
map("n", "<leader>wc", "<cmd>close<CR>", opts)

-- Telescope
map("n", "<leader>sf", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>st", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>sb", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>sl", "<cmd>Telescope resume<cr>", opts)

-- Lazy
map("n", "<leader>L", ":Lazy<CR>", opts)

-- LSP
map("n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
map("n", "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
map("n", "<leader>li", "<cmd>lua vim.lsp.buf.implementaion()<CR>", opts)
map("n", "<leader>lK", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
map("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
map("n", "<leader>lR", "<cmd>lua vim.lsp.buf.references()<CR>", opts)

-- Diagnostics
-- map("n", "<leader>dd", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
-- map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
-- map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

-- Git: Neogit
map("n", "<leader>gs", "<cmd>lua require('neogit').open()<CR>", opts)
map("n", "<leader>gc", "<cmd>lua require('neogit').open({ 'commit' })<CR>", opts)
map("n", "<leader>gb", "<cmd>lua require('neogit').open({ 'branch' })<CR>", opts)
map("n", "<leader>gp", "<cmd>lua require('neogit').open({ 'pull' })<CR>", opts)
map("n", "<leader>gP", "<cmd>lua require('neogit').open({ 'push' })<CR>", opts)
map("n", "<leader>gm", "<cmd>lua require('neogit').open({ 'merge' })<CR>", opts)
map("n", "<leader>gM", "<cmd>lua require('neogit').open({ 'rebase' })<CR>", opts)
map("n", "<leader>gd", "<cmd>lua require('neogit').open({ 'diff' })<CR>", opts)
map("n", "<leader>gl", "<cmd>lua require('neogit').open({ 'log' })<CR>", opts)
map("n", "<leader>gr", "<cmd>lua require('neogit').open({ 'reset' })<CR>", opts)
map("n", "<leader>gR", "<cmd>lua require('neogit').open({ 'revert' })<CR>", opts)
map("n", "<leader>gS", "<cmd>lua require('neogit').open({ 'stash' })<CR>", opts)
map("n", "<leader>gC", "<cmd>lua require('neogit').open({ 'cherry_pick' })<CR>", opts)

map("n", "<leader>gs", "<cmd>LazyGit<cr>", opts)

-- which key
local wk = require("which-key")
wk.add({
  -- Group labels with icons
  { "<leader>b", group = "Buffer", icon = "󰓩" },
  { "<leader>l", group = "LSP", icon = "" },
  { "<leader>s", group = "Search", icon = "" },
  { "<leader>d", group = "Diagnostics", icon = "" },
  { "<leader>x", group = "Trouble", icon = "" },
  { "<leader>g", group = "Git", icon = "󰊢" },
  { "<leader>w", group = "Windows " },

  -- Buffer actions
  { "<leader>bn", desc = "Next Buffer", icon = "" },
  { "<leader>bb", desc = "Previous Buffer", icon = "" },
  { "<leader>bd", desc = "Delete Buffer", icon = "" },
  { "<leader>q", desc = "Close Buffer", icon = "󰩈" },

  -- Telescope
  { "<leader>sf", desc = "Find Files", icon = "" },
  { "<leader>st", desc = "Text Search (Grep)", icon = "󰱽" },
  { "<leader>sb", desc = "Search Buffers", icon = "" },
  { "<leader>sl", desc = "Resume Search", icon = "󰑓" },

  -- windows
  { "<leader>bs", desc = "Horizontal Split", icon = "" },
  { "<leader>bv", desc = "Vertical Split", icon = "" },
  { "<leader>wv", desc = "Vertical Split", icon = "" },
  { "<leader>ws", desc = "Horizontal Split", icon = "" },
  { "<leader>w=", desc = "Equalize Size", icon = "󰿖" },
  { "<leader>wc", desc = "Close Window", icon = "󰅖" },
  { "<C-Up>", desc = "Resize Up", icon = "" },
  { "<C-Down>", desc = "Resize Down", icon = "" },
  { "<C-Left>", desc = "Resize Left", icon = "" },
  { "<C-Right>", desc = "Resize Right", icon = "" },

  -- Yazi
  { "<leader>e", mode = { "n", "v" }, desc = "Open yazi at current file", icon = "", cmd = "<cmd>Yazi<cr>" },
  { "<leader>cw", desc = "Open file manager in cwd", icon = "", cmd = "<cmd>Yazi cwd<cr>" },
  { "<c-up>", desc = "Resume last yazi session", icon = "󰐊", cmd = "<cmd>Yazi toggle<cr>" },

  -- LSP
  { "<leader>ld", desc = "Go to Definition", icon = "󰡷" },
  { "<leader>lD", desc = "Go to Declaration", icon = "󱡠" },
  { "<leader>li", desc = "Go to Implementation", icon = "" },
  { "<leader>lK", desc = "Hover", icon = "󰋼" },
  { "<leader>lr", desc = "Rename Symbol", icon = "󰑕" },
  { "<leader>la", desc = "Code Action", icon = "󰌶" },
  { "<leader>lR", desc = "Find References", icon = "󰌹" },

  -- Trouble (Diagnostics)
  { "<leader>xx", desc = "Diagnostics", icon = "" },
  { "<leader>xX", desc = "Buffer Diagnostics", icon = "" },
  { "<leader>xs", desc = "Symbols", icon = "󰓹" },
  { "<leader>xl", desc = "LSP Definitions/References", icon = "󰒕" },
  { "<leader>xL", desc = "Location List (Trouble)", icon = "󰍉" },
  { "<leader>xQ", desc = "Quickfix List", icon = "󰁨" },

  -- Neogit
  { "<leader>gs", desc = "Neogit Status", icon = "" },
  { "<leader>gc", desc = "Git Commit", icon = "" },
  { "<leader>gb", desc = "Branch", icon = "" },
  { "<leader>gp", desc = "Git Pull", icon = "󰜮" },
  { "<leader>gP", desc = "Git Push", icon = "󰜷" },
  { "<leader>gm", desc = "Merge", icon = "" },
  { "<leader>gM", desc = "Rebase", icon = "" },
  { "<leader>gd", desc = "View Diff", icon = "" },
  { "<leader>gl", desc = "Log", icon = "" },
  { "<leader>gr", desc = "Reset", icon = "󰑙" },
  { "<leader>gR", desc = "Revert", icon = "󰕍" },
  { "<leader>gS", desc = "Stash", icon = "" },
  { "<leader>gC", desc = "Cherry Pick", icon = "" },

  -- LazyGit
  { "<leader>gg", desc = "LazyGit", icon = "" },
})

-- Custom commands
require("conform").setup({
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 5000, lsp_format = "fallback" }
  end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})
