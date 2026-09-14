return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavor = "mocha",
      auto_integrations = true,
      no_italic = true,
      term_colors = true,
      transparent_background = true,
      styles = {
        comments = {},
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
      },
      color_overrides = {
        mocha = {
          base = "#0F0F17",
          mantle = "#0C0C13",
          crust = "#09090E",
        },
      },
}
}
