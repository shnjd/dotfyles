return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  event = 'VimEnter',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'
    local mocha = require("catppuccin.palettes").get_palette "mocha"

    local function shade_color(hex, factor)
      -- factor < 1 => darker, factor > 1 => lighter
      local r = tonumber(hex:sub(2, 3), 16)
      local g = tonumber(hex:sub(4, 5), 16)
      local b = tonumber(hex:sub(6, 7), 16)

      r = math.min(255, math.max(0, math.floor(r * factor)))
      g = math.min(255, math.max(0, math.floor(g * factor)))
      b = math.min(255, math.max(0, math.floor(b * factor)))

      return string.format("#%02x%02x%02x", r, g, b)
    end

    _Gopts = {
      position = 'center',
      hl = 'Type',
      wrap = 'overflow',
    }

    local logo = [[







                                              
       ███████████           █████      ██
      ███████████             █████ 
      ████████████████ ███████████ ███   ███████
     ████████████████ ████████████ █████ ██████████████
    █████████████████████████████ █████ █████ ████ █████
  ██████████████████████████████████ █████ █████ ████ █████
 ██████  ███ █████████████████ ████ █████ █████ ████ ██████
 ██████   ██  ███████████████   ██ █████████████████

      ]]


    -- Highlight groups configuration for each segment
    local header_hl = {
      { { "Red", 1, 1 } },
      { { "Red", 1, 1 } },
      { { "Red", 1, 1 } },
      { { "Red", 1, 1 } },
      { { "Red", 1, 1 } },
      { { "Red", 1, 1 } },
      { { "Red", 1, 1 } },
      { { "AlphaHeader0_0", 46, 48 } },
      {
        { "AlphaHeader1_0", 7,  22 },
        { "AlphaHeader1_1", 33, 40 },
        { "AlphaHeader1_2", 40, 50 }
      },
      {
        { "AlphaHeader2_0", 6,  21 },
        { "AlphaHeader2_1", 33, 45 },
      },
      {
        { "AlphaHeader3_0", 6,  19 },
        { "AlphaHeader3_1", 19, 20 },
        { "AlphaHeader3_2", 20, 35 },
        { "AlphaHeader3_3", 35, 45 },
        { "AlphaHeader3_4", 45, 90 },
      },
      {
        { "AlphaHeader4_0", 5,  18 },
        { "AlphaHeader4_1", 18, 36 },
        { "AlphaHeader4_2", 36, 45 },
        { "AlphaHeader4_3", 45, 90 }
      },
      {
        { "AlphaHeader5_0", 4,  17 },
        { "AlphaHeader5_1", 17, 24 },
        { "AlphaHeader5_2", 24, 28 },
        { "AlphaHeader5_3", 28, 37 },
        { "AlphaHeader5_4", 37, 46 },
        { "AlphaHeader5_5", 46, 90 },
      },
      {
        { "AlphaHeader6_0", 2,  17 },
        { "AlphaHeader6_1", 17, 38 },
        { "AlphaHeader6_2", 38, 45 },
        { "AlphaHeader6_3", 46, 90 },
      },
      {
        { "AlphaHeader7_0", 1,  17 },
        { "AlphaHeader7_1", 17, 38 },
        { "AlphaHeader7_2", 38, 45 },
        { "AlphaHeader7_3", 46, 90 },
      },
      {
        { "AlphaHeader8_0", 1,  37 },
        { "AlphaHeader8_1", 37, 91 },
      }
    }

    vim.api.nvim_set_hl(0, "AlphaHeader0_0", { fg = shade_color(mocha.teal, 0.65) })
    vim.api.nvim_set_hl(0, "AlphaHeader1_0", { fg = shade_color(mocha.peach, 0.7) })
    vim.api.nvim_set_hl(0, "AlphaHeader1_1", { fg = shade_color(mocha.green, 0.7) })
    vim.api.nvim_set_hl(0, "AlphaHeader1_2", { fg = shade_color(mocha.teal, 0.7) })
    vim.api.nvim_set_hl(0, "AlphaHeader2_0", { fg = shade_color(mocha.peach, 0.75) })
    vim.api.nvim_set_hl(0, "AlphaHeader2_1", { fg = shade_color(mocha.green, 0.75) })
    vim.api.nvim_set_hl(0, "AlphaHeader3_0", { fg = shade_color(mocha.peach, 0.8) })
    vim.api.nvim_set_hl(0, "AlphaHeader3_1", { fg = shade_color(mocha.peach, 0.7) })
    vim.api.nvim_set_hl(0, "AlphaHeader3_2", { fg = shade_color(mocha.yellow, 0.8) })
    vim.api.nvim_set_hl(0, "AlphaHeader3_3", { fg = shade_color(mocha.green, 0.8) })
    vim.api.nvim_set_hl(0, "AlphaHeader3_4", { fg = shade_color(mocha.teal, 0.8) })
    vim.api.nvim_set_hl(0, "AlphaHeader4_0", { fg = shade_color(mocha.peach, 0.85) })
    vim.api.nvim_set_hl(0, "AlphaHeader4_1", { fg = shade_color(mocha.yellow, 0.85) })
    vim.api.nvim_set_hl(0, "AlphaHeader4_2", { fg = shade_color(mocha.green, 0.85) })
    vim.api.nvim_set_hl(0, "AlphaHeader4_3", { fg = shade_color(mocha.teal, 0.85) })
    vim.api.nvim_set_hl(0, "AlphaHeader5_0", { fg = shade_color(mocha.peach, 0.9) })
    vim.api.nvim_set_hl(0, "AlphaHeader5_1", { fg = shade_color(mocha.yellow, 0.9) })
    vim.api.nvim_set_hl(0, "AlphaHeader5_2", { fg = shade_color(mocha.peach, 0.4) })
    vim.api.nvim_set_hl(0, "AlphaHeader5_3", { fg = shade_color(mocha.yellow, 0.9) })
    vim.api.nvim_set_hl(0, "AlphaHeader5_4", { fg = shade_color(mocha.green, 0.9) })
    vim.api.nvim_set_hl(0, "AlphaHeader5_5", { fg = shade_color(mocha.teal, 0.9) })
    vim.api.nvim_set_hl(0, "AlphaHeader6_0", { fg = shade_color(mocha.peach, 0.95) })
    vim.api.nvim_set_hl(0, "AlphaHeader6_1", { fg = shade_color(mocha.yellow, 0.95) })
    vim.api.nvim_set_hl(0, "AlphaHeader6_2", { fg = shade_color(mocha.green, 0.95) })
    vim.api.nvim_set_hl(0, "AlphaHeader6_3", { fg = shade_color(mocha.teal, 0.95) })
    vim.api.nvim_set_hl(0, "AlphaHeader7_0", { fg = mocha.peach })
    vim.api.nvim_set_hl(0, "AlphaHeader7_1", { fg = mocha.yellow })
    vim.api.nvim_set_hl(0, "AlphaHeader7_2", { fg = mocha.green })
    vim.api.nvim_set_hl(0, "AlphaHeader7_3", { fg = mocha.teal })
    vim.api.nvim_set_hl(0, "AlphaHeader8_0", { fg = shade_color(mocha.peach, 0.4) })
    vim.api.nvim_set_hl(0, "AlphaHeader8_1", { fg = shade_color(mocha.green, 0.4) })

    local utils = require('alpha.utils')

    -- Split logo into lines
    local logoLines = {}
    for line in logo:gmatch '[^\r\n]+' do
      table.insert(logoLines, line)
    end

    local header_val = vim.split(logo, '\n')
    header_hl = utils.charhl_to_bytehl(header_hl, header_val, false)

    dashboard.section.header.opts.hl = header_hl
    dashboard.section.header.val = header_val




    local init_path                   = vim.fn.stdpath('config')
    dashboard.section.buttons.val     = {
      dashboard.button('n', '  New file', ':ene <BAR> startinsert<CR>'),
      dashboard.button('r', '󰄉  Recent files', ':Telescope oldfiles<CR>'),
      dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
      dashboard.button("m", "  Mason", ":Mason<CR>"),
      dashboard.button('c', '  NVIM Config', ':cd ' .. init_path .. '<CR>:e init.lua<CR>'),
      dashboard.button('q', '󰿅  Quit', '<cmd>q<CR>'),
    }

    dashboard.section.buttons.opts.hl = 'AlphaHeader1_0'

    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyVimStarted',
      desc = 'Add Alpha dashboard footer',
      once = true,
      callback = function()
        local stats = require('lazy').stats()
        local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
        dashboard.section.footer.val = {
          ' ', ' ', ' ', ' Loaded ' .. stats.count .. ' plugins in ' .. ms .. ' ms ', ' ', ' ', ' ', ' ', ' ', ' ',
          ' ', ' ', ' ', ' ', ' ', ' ', ' ',
        }
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    -- Greeting section
    local function getGreeting(name)
      local tableTime = os.date '*t'
      local hour = tableTime.hour
      local greetingsTable = {
        [0] = 'Hello',
        [1] = ' Sleep well',
        [2] = ' Good morning',
        [3] = ' Good afternoon',
        [4] = ' Good evening',
        [5] = '󰖔 Good night',
      }
      local greetingIndex = 0
      if hour == 23 or hour < 7 then
        greetingIndex = 1
      elseif hour < 12 then
        greetingIndex = 2
      elseif hour >= 12 and hour < 18 then
        greetingIndex = 3
      elseif hour >= 18 and hour < 21 then
        greetingIndex = 4
      elseif hour >= 21 then
        greetingIndex = 5
      end
      return (greetingsTable[greetingIndex]) .. ' ' .. name
    end

    local greeting = getGreeting("shinjith")

    local greeting_section = {
      type = "text",
      val = greeting,
      opts = {
        position = "center",
      },
    }

    local function command_exists(cmd)
      local handle = io.popen("which " .. cmd .. " 2>/dev/null")
      if handle then
        local result = handle:read("*a")
        handle:close()
        return result ~= ""
      end
      return false
    end

    local function get_fortune()
      if command_exists("fortune") then
        local handle = io.popen("fortune -s")
        if handle then
          local result = handle:read("*a")
          handle:close()
          return result
        end
      end
      return 'Welcome back!'
    end

    local function center_text(lines)
      local width = vim.api.nvim_get_option("columns") -- current Neovim width
      local centered = {}
      for _, line in ipairs(lines) do
        local pad = math.floor((width - #line) / 2)
        table.insert(centered, string.rep(" ", pad) .. line)
      end
      return centered
    end

    vim.api.nvim_set_hl(0, "AlphaQuote", { fg = mocha.subtext0 })

    local quote_section = {
      type = "text",
      val = center_text(vim.split(get_fortune(), "\n")),
      opts = {
        position = "left",
        hl = "AlphaQuote"
      },
    }

    dashboard.config.layout = {
      dashboard.section.header,
      greeting_section,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      dashboard.section.footer,
      quote_section,
    }

    -- Hide all the unnecessary visual elements while on the dashboard, and add
    -- them back when leaving the dashboard.
    local group = vim.api.nvim_create_augroup('CleanDashboard', {})

    vim.api.nvim_create_autocmd('User', {
      group = group,
      pattern = 'AlphaReady',
      callback = function()
        -- vim.opt.showtabline = 0
        -- vim.opt.showmode = true
        -- vim.opt.laststatus = 3
        vim.opt.showcmd = false
        vim.opt.ruler = false
      end,
    })

    vim.api.nvim_create_autocmd('BufUnload', {
      group = group,
      pattern = '<buffer>',
      callback = function()
        -- vim.opt.showtabline = 0
        -- vim.opt.showmode = true
        -- vim.opt.laststatus = 3
        vim.opt.showcmd = true
        vim.opt.ruler = true
      end,
    })
    dashboard.opts.opts.noautocmd = true
    alpha.setup(dashboard.opts)
  end,
}
