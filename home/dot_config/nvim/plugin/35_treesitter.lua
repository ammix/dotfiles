-- Languages
local languages = {
  "bash",
  "fish",
  "nu",
  "c",
  "cpp",
  "css",
  "query",
  "diff",
  "editorconfig",
  "ini",
  "luadoc",
  "luap",
  "git_config",
  "git_rebase",
  "gitcommit",
  "gitignore",
  "gitattributes",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "nix",
  "ron",
  "just",
  "slint",
  "python",
  "regex",
  "rust",
  "toml",
  "typescript",
  "tsx",
  "vim",
  "yaml",
  "zig",
  "odin",
  "typst",
  "vimdoc",
  "xml",
}

require("nvim-treesitter").install(languages)

-- Runtime
vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable treesitter highlighting and indent",
  callback = function()
    local ok = pcall(vim.treesitter.start)
    if not ok then
      return
    end

    vim.bo.indentexpr = require("nvim-treesitter").indentexpr
  end,
})

require("nvim-ts-autotag").setup()
