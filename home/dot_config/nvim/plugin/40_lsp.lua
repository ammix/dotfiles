local map = vim.keymap.set

-- vim.o.completeopt = "menuone,popup,preinsert"
-- vim.o.autocomplete = true

-- map("i", "<C-x><C-f>", function()
--   local bufdir = vim.fn.expand("%:p:h")
--   local cwd = vim.fn.getcwd()
--   vim.cmd.lcd(bufdir)
--   vim.defer_fn(function()
--     vim.cmd.lcd(cwd)
--   end, 100)
--   return "<C-x><C-f>"
-- end, { expr = true, desc = "Complete filenames relative to buffer" })

-- Diagnostics
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  },
})

-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })
    local opts = { buffer = ev.buf }
    map("n", "<leader>lr", "<CMD>lsp restart<CR>", { desc = "Restart LSP Server" })
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    map("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "[G]oto [D]efinition" })
    map("n", "grd", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "[G]oto [D]eclaration" })

    map("n", "grr", function()
      require("mini.extra").pickers.lsp({ scope = "references" })
    end, { buffer = ev.buf, desc = "[G]oto [R]eferences" })

    map("n", "gri", function()
      require("mini.extra").pickers.lsp({ scope = "implementation" })
    end, { buffer = ev.buf, desc = "[G]oto [I]mplementation" })

    map("n", "grt", function()
      require("mini.extra").pickers.lsp({ scope = "type_definition" })
    end, { buffer = ev.buf, desc = "[G]oto [T]ype Definition" })
  end,
})

-- Enable servers
vim.lsp.enable({
  "lua_ls",
  "yamlls",
  "basedpyright",
  "bashls",
  "nixd",
  "elixirls",
  "ols",
  "tinymist",
  "gopls",
  "rust_analyzer",
  "zls",
  "jsonls",
  "slint_lsp",
  "clangd",
  "harper_ls",
})

-- trouble
require("trouble").setup({})

map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
