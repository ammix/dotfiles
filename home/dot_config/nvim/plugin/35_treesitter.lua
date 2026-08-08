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

vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable treesitter highlighting and indent",
  callback = function(ctx)
    local ok = pcall(vim.treesitter.start)
    if not ok then
      return
    end

    local noIndent = {
      -- add filetypes
    }
    if not vim.list_contains(noIndent, ctx.match) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Autotag
require("nvim-ts-autotag").setup()
