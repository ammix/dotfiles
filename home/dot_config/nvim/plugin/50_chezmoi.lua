local chezmoi = require("chezmoi")

local source_result = vim.system({ "chezmoi", "source-path" }, { text = true }):wait()
if source_result.code ~= 0 then
  error(source_result.stderr)
end
local source_dir = assert(vim.uv.fs_realpath(vim.trim(source_result.stdout)))

chezmoi.setup({
  extra_args = { "--source", source_dir },
  edit = {
    watch = true,
  },
})

local chezmoi_edit = require("chezmoi.commands.__edit")
local chezmoi_pick = require("chezmoi.pick")
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
  chezmoi_pick.mini(nil, {
    "--path-style",
    "absolute",
    "--include",
    "files",
    "--exclude",
    "externals",
  })
end, { desc = "Find chezmoi files" })
