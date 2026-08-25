-- Bootstrap
vim.loader.enable()

local gh = function(x)
  return "https://github.com/" .. x
end
local cb = function(x)
  return "https://codeberg.org/" .. x
end

-- Updates
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local data = ev.data
    local kind = data.kind
    local name = data.spec.name

    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      if not data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

-- Plugins
vim.pack.add({
  gh("catppuccin/nvim"),
  gh("nvim-mini/mini.nvim"),
  gh("saghen/blink.lib"),
  gh("saghen/blink.cmp"),
  gh("ammix/chezmoi.nvim"),
  gh("nvim-treesitter/nvim-treesitter"),
  gh("neovim/nvim-lspconfig"),
  gh("stevearc/conform.nvim"),
  gh("mfussenegger/nvim-lint"),
  gh("windwp/nvim-ts-autotag"),
  gh("folke/trouble.nvim"),
  gh("chomosuke/typst-preview.nvim"),
  gh("voldikss/vim-floaterm"),
  gh("NeogitOrg/neogit"),
  cb("andyg/leap.nvim"),
  gh("stevearc/oil.nvim"),
})
