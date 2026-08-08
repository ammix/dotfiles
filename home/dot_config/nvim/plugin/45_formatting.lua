-- Conform
require("conform").setup({
  default_format_opts = {
    timeout_ms = 3000,
    async = false,
    quiet = false,
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "nixfmt" },
    fish = { "fish_indent" },
    sh = { "shfmt" },
    python = { "ruff_fix", "ruff_format" },
    rust = { "rustfmt" },
    odin = { "odinfmt" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    vue = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    less = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    ["markdown.mdx"] = { "prettier" },
    graphql = { "prettier" },
    handlebars = { "prettier" },
  },
  formatters = {
    injected = { options = { ignore_errors = true } },
    prettier = {
      condition = function(_, ctx)
        return vim.fs.find(
          { ".prettierrc", ".prettierrc.json", ".prettierrc.js", "prettier.config.js", "package.json" },
          { path = ctx.filename, upward = true }
        )[1] ~= nil
      end,
    },
  },
})

-- Lint
local lint = require("lint")
lint.linters_by_ft = lint.linters_by_ft or {}
lint.linters_by_ft["markdown"] = nil
lint.linters_by_ft["text"] = nil

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    if vim.bo.modifiable then
      lint.try_lint()
    end
  end,
})

-- Keymaps
local map = vim.keymap.set

map("n", "<leader>lf", function()
  require("conform").format()
end, { desc = "Format Buffer" })

map({ "n", "v" }, "<leader>lF", function()
  require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
end, { desc = "Format Injected Langs" })
