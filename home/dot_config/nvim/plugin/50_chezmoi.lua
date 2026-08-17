local source_dir = vim.fn.expand("~/.local/share/chezmoi")
local home_dir = vim.fs.joinpath(source_dir, "home")

require("chezmoi").setup({
  edit = {
    watch = true,
  },
  extra_args = { "--source", source_dir },
})

local chezmoi_edit = require("chezmoi.commands.__edit")
local mini_pick = require("mini.pick")
local pick_command = { "rg", "--files", "--hidden", "--glob", "!.git", home_dir }
local watch_group = vim.api.nvim_create_augroup("chezmoi_edit_watch", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = watch_group,
  pattern = vim.fs.joinpath(home_dir, "*"),
  callback = function(event)
    vim.schedule(function()
      chezmoi_edit.watch(event.buf)
    end)
  end,
})

vim.keymap.set("n", "<leader>fc", function()
  mini_pick.builtin.cli({ command = pick_command }, { source = { name = "Chezmoi" } })
end, { desc = "Find chezmoi files" })
