# dotfyles

Personal dotfiles for an Arch Linux + KDE Plasma desktop, managed with
[GNU Stow](https://www.gnu.org/software/stow/). The theme is Catppuccin Mocha
throughout.

## Layout

Each top-level directory is a Stow package that mirrors `$HOME`:

| Package     | Target                              | What it configures                       |
| ----------- | ----------------------------------- | ---------------------------------------- |
| `alacritty` | `~/.config/alacritty/`              | Terminal emulator + colorscheme          |
| `breeze`    | `~/.config/breezerc`                | Breeze window decoration / style tweaks  |
| `dolphinrc` | `~/.config/dolphinrc`               | Dolphin file manager                     |
| `fontconfig`| `~/.config/fontconfig/fonts.conf`   | Synthetic oblique for fonts lacking italics |
| `gtk`       | `~/.config/xsettingsd/`             | GTK theme, icons, cursor, font hinting   |
| `kde`       | `~/.config/kde*`, `kate`, `kdenlive`| Plasma globals, defaults, apps           |
| `lazygit`   | `~/.config/lazygit/`                | Lazygit                                  |
| `nvim`      | `~/.config/nvim/`                   | Neovim (lazy.nvim based)                 |
| `opencode`  | `~/.config/opencode/`               | opencode AI agent + plugins              |
| `yazi`      | `~/.config/yazi/`                   | Yazi file manager + Catppuccin flavors   |
| `zsh`       | `~/.zshrc`                          | Zsh shell                                |
| `scripts`   | —                                   | Helper scripts (not stowed)              |

## Install

```sh
git clone https://github.com/shnjd/dotfyles ~/dotfyles
cd ~/dotfyles
stow alacritty nvim zsh yazi lazygit   # or any subset of packages
```

## Packages

What the configs expect to be installed.

### Core

- `stow` — symlink management
- `git`, `gnupg` (signed commits via the `gcs` alias), `jq`
- `zsh`, [Oh My Zsh](https://ohmyz.sh/), [pure](https://github.com/sindresorhus/pure) prompt
- `alacritty` — default `$TERMINAL`
- `neovim` — default `$EDITOR`
- `yazi`, `lazygit`

### Shell (`zsh`)

- Oh My Zsh plugins: `git`, `z`, `pip`, `npm`, `sudo`, `pnpm`, `yarn`
- Toolchains on `$PATH`: `nvm` (Node), `pnpm`, `bun`, `cargo` (Rust),
  Homebrew (Linuxbrew), Android SDK (`emulator`, `platform-tools`)
- Rootless Docker (`DOCKER_HOST` points at `$XDG_RUNTIME_DIR/docker.sock`)
- Arch maintenance aliases: `pacman`, `paccache` (`pacman-contrib`), `yay`,
  `rate-mirrors`
- `ente-cli` (aliased to `ente`)
- `opencode`

### Neovim

Plugins managed by [lazy.nvim](https://github.com/folke/lazy.nvim):

- **UI:** `catppuccin/nvim`, `folke/which-key.nvim`, `rcarriga/nvim-notify`,
  `nvim-tree/nvim-web-devicons`, greeter and status bar
- **LSP & completion:** `neovim/nvim-lspconfig`, `mason-org/mason.nvim`,
  `mason-org/mason-lspconfig.nvim`, `hrsh7th/nvim-cmp` (+ `cmp-nvim-lsp`,
  `cmp-buffer`, `cmp-path`, `cmp-nvim-lua`)
- **Syntax:** `nvim-treesitter/nvim-treesitter`
- **Git:** `NeogitOrg/neogit`, `sindrets/diffview.nvim`, `kdheepak/lazygit.nvim`
- **Navigation:** `nvim-telescope/telescope.nvim`, `mikavilpas/yazi.nvim`
- **Editing:** `folke/trouble.nvim`, `folke/todo-comments.nvim`,
  `gbprod/yanky.nvim` (with `kkharji/sqlite.lua`)
- **Libraries:** `nvim-lua/plenary.nvim`

Language servers installed via Mason: `ts_ls`, `html`, `cssls`, `jsonls`,
`lua_ls`, `eslint`, `tailwindcss`, `emmet_ls`, `yamlls`, `dockerls`.

Treesitter parsers: `c`, `lua`, `vim`, `vimdoc`, `query`, `javascript`,
`typescript`, `html`, `json`, `markdown`.

### opencode

- Plugins: `@mohak34/opencode-notifier`, `oh-my-opencode-slim`
- Node dependency: `@opencode-ai/plugin`

### Desktop (KDE Plasma)

- Global theme / colors / splash: **Catppuccin Mocha Green**
- Window decoration: `CatppuccinMocha-Modern` (Aurorae)
- Cursors: `Catppuccin-Mocha-Green-Cursors`
- Icons: `papirus-icon-theme` (Papirus-Dark)
- GTK: Breeze theme via `xsettingsd`
- Apps: Dolphin, Kate, Kdenlive, Elisa

### Fonts

- `ttf-hack-nerd` (Hack Nerd Font) — terminal and KDE UI/monospace
- Overpass — KDE menus, toolbars and window titles

## Scripts

`scripts/backup-secrets.sh` moves secrets (SSH keys, GPG keys, `.env` files,
keystores) between OS installs. Requires `bash`, `tar` and `gpg`.

```sh
scripts/backup-secrets.sh backup /mnt/encrypted/secrets [--dry-run]
/mnt/encrypted/secrets/backup-secrets.sh restore
```

Keep the backup directory on an encrypted drive and never commit it.
