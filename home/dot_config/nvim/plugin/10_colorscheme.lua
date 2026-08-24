require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
  },
  custom_highlights = {
    ["@keyword.return"] = { bold = true },
    ["@variable.builtin"] = { bold = true },
    ["@variable.parameter.builtin"] = { bold = true },
    ["@constant.builtin"] = { bold = true },
    ["@module.builtin"] = { bold = true },
    ["@attribute.builtin"] = { bold = true },
    ["@function.builtin"] = { bold = true },
  },
  default_integrations = true,
  auto_integrations = false,
  integrations = {
    blink_cmp = true,
    gitsigns = true,
    nvimtree = true,
    treesitter = true,
    notify = true,
    noice = true,
    mini = {
      enabled = true,
      indentscope_color = "",
    },
    leap = true,
    lsp_trouble = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
      inlay_hints = {
        background = true,
      },
    },
  },
})

vim.cmd.colorscheme("catppuccin")
