local au = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

-- Events
au({ "TextYankPost", "TextPutPost" }, {
  group = ag("MiniBasicsHighlight", { clear = true }),
  pattern = "*",
  callback = function()
    vim.hl.hl_op({ timeout = 200 })
  end,
})

au("TermOpen", {
  group = ag("MiniBasicsTerm", { clear = true }),
  pattern = "*",
  command = "startinsert",
})

-- Commands
vim.api.nvim_create_user_command("BdelOther", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_valid(buf) and buf ~= current_buf and vim.bo[buf].buflisted then
      pcall(vim.api.nvim_buf_delete, buf)
    end
  end
end, { desc = "Delete all other listed buffers" })
