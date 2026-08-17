local source_dir = vim.fn.expand("~/.local/share/chezmoi")

require("chezmoi").setup({
  edit = {
    watch = true,
  },
  extra_args = { "--source", source_dir },
})

local chezmoi_edit = require("chezmoi.commands.__edit")
local chezmoi_pick = require("chezmoi.pick")
local pick_args = { "--path-style", "absolute", "--include", "files", "--exclude", "externals" }
local watch_group = vim.api.nvim_create_augroup("chezmoi_edit_watch", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = watch_group,
  pattern = vim.fs.joinpath(source_dir, "home", "*"),
  callback = function(event)
    vim.schedule(function()
      chezmoi_edit.watch(event.buf)
    end)
  end,
})

vim.keymap.set("n", "<leader>fc", function()
  chezmoi_pick.mini(nil, pick_args)
end, { desc = "Find chezmoi files" })
