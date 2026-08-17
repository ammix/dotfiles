local chezmoi = require("chezmoi")
local chezmoi_edit = require("chezmoi.commands.__edit")
local chezmoi_pick = require("chezmoi.pick")

chezmoi.setup({
  edit = {
    watch = true,
  },
})

local source_result = vim.system({ "chezmoi", "source-path" }, { text = true }):wait()
if source_result.code ~= 0 then
  error(source_result.stderr)
end
local source_dir = vim.trim(source_result.stdout)
local watch_group = vim.api.nvim_create_augroup("chezmoi_edit_watch", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = watch_group,
  pattern = vim.fs.joinpath(source_dir, "*"),
  callback = function(event)
    vim.schedule(function()
      chezmoi_edit.watch(event.buf)
    end)
  end,
})

vim.keymap.set("n", "<leader>fc", function()
  chezmoi_pick.mini()
end, { desc = "Find chezmoi files" })
