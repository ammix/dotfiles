local au = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

-- Highlight on yank
au("TextYankPost", {
  group = ag("MiniBasicsYank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Start insert in terminal
au("TermOpen", {
  group = ag("MiniBasicsTerm", { clear = true }),
  pattern = "*",
  command = "startinsert",
})

-- Refresh buffers when focus returns (e.g. after closing a tmux popup)
au("FocusGained", {
  group = ag("TmuxPopupRefresh", { clear = true }),
  callback = function()
    vim.cmd("checktime")
  end,
})

-- Delete all buffers except current
vim.api.nvim_create_user_command("BdelOther", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_valid(buf) and buf ~= current_buf and vim.bo[buf].buflisted then
      pcall(vim.api.nvim_buf_delete, buf, {})
    end
  end
end, { desc = "Delete all other listed buffers" })
