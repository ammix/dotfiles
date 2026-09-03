local map = vim.keymap.set

-- Navigation
map({ "n", "v" }, "j", "gj")
map({ "n", "v" }, "k", "gk")
map("n", "gV", "`[v`]", { desc = "Select last changed text" })

map("i", "<M-h>", "<Left>", { desc = "Move Left" })
map("i", "<M-j>", "<Down>", { desc = "Move Down" })
map("i", "<M-k>", "<Up>", { desc = "Move Up" })
map("i", "<M-l>", "<Right>", { desc = "Move Right" })
map("c", "<M-h>", "<Left>", { desc = "Move Left" })
map("c", "<M-l>", "<Right>", { desc = "Move Right" })
map("t", "<M-h>", "<Left>", { desc = "Move Left" })
map("t", "<M-j>", "<Down>", { desc = "Move Down" })
map("t", "<M-k>", "<Up>", { desc = "Move Up" })
map("t", "<M-l>", "<Right>", { desc = "Move Right" })

-- Windows
map("n", "<leader>w", "<C-w>", { desc = "Window Prefix" })

map("n", "<C-Left>", "<C-w><", { desc = "Resize Left" })
map("n", "<C-Down>", "<C-w>-", { desc = "Resize Down" })
map("n", "<C-Up>", "<C-w>+", { desc = "Resize Up" })
map("n", "<C-Right>", "<C-w>>", { desc = "Resize Right" })

-- Actions
map("n", "<leader>ms", "1Q", { desc = "Add cursors at search matches" })
map("n", "<leader>mf", "q=", { desc = "Toggle multicursor follow mode" })
map({ "n", "v" }, "gy", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "v" }, "gp", '"+p', { desc = "Paste from system clipboard" })

map("n", "<Esc>", "<CMD>nohlsearch<CR>")
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("n", "<leader>fs", "<CMD>w<CR>", { desc = "Save file" })
map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "<leader>qq", "<CMD>q<CR>", { desc = "Quit" })

map("n", "<leader>bb", "<CMD>e #<CR>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bq", "<CMD>bd<CR>", { desc = "Delete Buffer and Window" })
map("n", "<leader>bo", "<CMD>BdelOther<CR>", { desc = "Delete other buffers" })

map("n", "<leader>cr", "<CMD>make run<CR>", { desc = "Compile and run" })
map("n", "<leader>cc", "<CMD>make build<CR>", { desc = "Compile" })

-- Plugins
map("n", "<leader>L", function()
  vim.pack.update()
end, { desc = "Update plugins" })

map("n", "<leader>u", "<CMD>Undotree<CR>", { desc = "Undotree" })

map("n", "<leader>t", "<CMD>FloatermToggle<CR>", { desc = "Toggle terminal" })

map("n", "<leader>gg", "<CMD>Neogit<CR>", { desc = "Neogit" })
map("n", "<leader>gj", "<CMD>FloatermNew jjui<CR>", { desc = "Jujutsu UI" })
