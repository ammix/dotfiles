vim.loader.enable()

local gh = function(x)
  return "https://github.com/" .. x
end
local cb = function(x)
  return "https://codeberg.org/" .. x
end

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local data = ev.data or {}
    local spec = data.spec or {}
    local kind = data.kind
    local name = spec.name

    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      if not data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  gh("catppuccin/nvim"),
  gh("nvim-mini/mini.nvim"),
  gh("nvim-lua/plenary.nvim"),
  gh("xvzc/chezmoi.nvim"),
  gh("nvim-treesitter/nvim-treesitter"),
  gh("neovim/nvim-lspconfig"),
  gh("stevearc/conform.nvim"),
  gh("mfussenegger/nvim-lint"),
  gh("windwp/nvim-ts-autotag"),
  gh("folke/trouble.nvim"),
  gh("chomosuke/typst-preview.nvim"),
  gh("voldikss/vim-floaterm"),
  cb("andyg/leap.nvim"),
  gh("stevearc/oil.nvim"),
})
