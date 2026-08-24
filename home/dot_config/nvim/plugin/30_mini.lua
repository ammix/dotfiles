-- Modules
require("mini.extra").setup()
local gen_loader = require("mini.snippets").gen_loader
require("mini.snippets").setup({
  snippets = {
    gen_loader.from_lang(),
  },
})
require("mini.snippets").start_lsp_server()
require("mini.ai").setup()
require("mini.align").setup()
require("mini.icons").setup()
require("mini.comment").setup()
require("mini.move").setup()
require("mini.cursorword").setup()
require("mini.trailspace").setup()
require("mini.jump").setup()
require("mini.cmdline").setup()
require("mini.pick").setup()
require("mini.completion").setup()
require("mini.input").setup()

-- Interface
local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = { "n", "x" }, keys = "<Leader>" },

    -- `[` and `]` keys
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },

    -- Built-in completion
    { mode = "i", keys = "<C-x>" },

    -- `g` key
    { mode = { "n", "x" }, keys = "g" },

    -- Marks
    { mode = { "n", "x" }, keys = "'" },
    { mode = { "n", "x" }, keys = "`" },

    -- Registers
    { mode = { "n", "x" }, keys = '"' },
    { mode = { "i", "c" }, keys = "<C-r>" },

    -- Window commands
    { mode = "n", keys = "<C-w>" },

    -- `z` key
    { mode = { "n", "x" }, keys = "z" },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
})

require("mini.notify").setup({
  window = {
    winblend = 100,
  },
})

require("mini.sessions").setup()

local starter = require("mini.starter")
starter.setup({
  header = "Welcome back",
  footer = "",
  items = {
    starter.sections.sessions(),
    -- starter.sections.recent_files(5, true, false),
    starter.sections.recent_files(5, false, false),
    starter.sections.builtin_actions(),
  },
})

require("mini.indentscope").setup({
  symbol = "│",
  options = { try_as_border = true },
})

require("mini.files").setup({
  options = {
    use_as_default_explorer = false,
  },
})

-- Git
require("mini.git").setup()

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniGitUpdated",
  callback = function(ev)
    local summary = vim.b[ev.buf].minigit_summary
    vim.b[ev.buf].minigit_summary_string = summary and (summary.head_name or "") or ""
  end,
})
require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = "▎", change = "▎", delete = "" },
  },
})

-- Editing
require("mini.pairs").setup({
  modes = { insert = true, command = true, terminal = true },
  -- skip autopair when next character is one of these
  skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
  -- skip autopair when the cursor is inside these treesitter nodes
  skip_ts = { "string" },
  -- skip autopair when next character is closing pair
  -- and there are more closing pairs than opening pairs
  skip_unbalanced = true,
  -- better deal with markdown code blocks
  markdown = true,
})

require("mini.splitjoin").setup({
  mappings = {
    toggle = "",
    split = "gS",
    join = "gJ",
  },
})

require("mini.surround").setup({
  mappings = {
    add = "gsa", -- Add surrounding in Normal and Visual modes
    delete = "gsd", -- Delete surrounding
    find = "gsf", -- Find surrounding (to the right)
    find_left = "gsF", -- Find surrounding (to the left)
    highlight = "gsh", -- Highlight surrounding
    replace = "gsr", -- Replace surrounding
    update_n_lines = "gsn", -- Update `n_lines`
  },
})

-- Highlights
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
  highlighters = {
    fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
    hack = { pattern = "HACK", group = "MiniHipatternsHack" },
    todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
    note = { pattern = "NOTE", group = "MiniHipatternsNote" },

    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

-- Statusline
local statusline = require("mini.statusline")
statusline.setup({
  use_icons = true,
  content = {
    active = function()
      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      local git = statusline.section_git({ trunc_width = 40 })
      local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
      local filename = statusline.section_filename()
      local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
      local location = statusline.section_location()
      local search = statusline.section_searchcount({ trunc_width = 75 })

      return statusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { git } },
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=", -- Right align from here
        { hl = "MiniStatuslineFilename", strings = { "%S" } },
        { hl = "MiniStatuslineDevinfo", strings = { diagnostics } },
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = mode_hl, strings = { search, location } },
      })
    end,
  },
})

---@diagnostic disable: duplicate-set-field
statusline.section_location = function()
  return "%2l:%-2v"
end

statusline.section_filename = function()
  local filename = vim.fn.expand("%:t")
  local parent = vim.fn.expand("%:h:t")
  local modified = vim.bo.modified and " [+]" or ""

  if filename == "" then
    return "[No Name]" .. modified
  end
  if parent == "." or parent == "" then
    return filename .. modified
  end

  return parent .. "/" .. filename .. modified
end

statusline.section_fileinfo = function(args)
  local filetype = vim.bo.filetype

  -- Get icon using mini.icons instead of nvim-web-devicons
  if filetype ~= "" then
    local has_icons, icons = pcall(require, "mini.icons")
    if has_icons then
      local icon = icons.get("filetype", filetype) or ""
      if icon ~= "" then
        filetype = icon .. " " .. filetype
      end
    end
  end

  if statusline.is_truncated(args.trunc_width) or vim.bo.buftype ~= "" then
    return filetype
  end

  return string.format("%s%s", filetype, filetype == "" and "" or " ")
end

-- Keymaps
local map = vim.keymap.set

map("n", "<leader>qs", function()
  local session_name = vim.fn.input("Session name: ")
  if session_name and session_name ~= "" then
    require("mini.sessions").write(session_name)
  end
end, { desc = "Save session" })

map("n", "<leader>qd", function()
  require("mini.sessions").select("delete")
end, { desc = "Delete session" })

map("n", "<leader>ql", function()
  require("mini.sessions").write("Session.vim")
end, { desc = "Save local session" })

map("n", "<leader>e", function()
  require("mini.files").open()
end, { desc = "Open files" })

map("n", "<leader>,", function()
  require("mini.pick").builtin.buffers()
end, { desc = "Buffers" })

map("n", "<leader>/", function()
  require("mini.pick").builtin.grep_live()
end, { desc = "Grep" })

map("n", "<leader><space>", function()
  require("mini.pick").builtin.files()
end, { desc = "Find Files" })

map("n", "<leader>ff", function()
  require("mini.pick").builtin.cli({
    command = { "fd", "--type=f", "--hidden", "--no-ignore", "--no-follow", "--color=never" },
  })
end, { desc = "Find Files (all)" })

map("n", "<leader>fr", function()
  require("mini.extra").pickers.oldfiles()
end, { desc = "Recent Files" })

map("n", "<leader>fg", function()
  require("mini.extra").pickers.git_files()
end, { desc = "Git Files" })

map("n", "<leader>sd", function()
  require("mini.extra").pickers.diagnostic()
end, { desc = "Search Diagnostics" })

map("n", "<leader>sm", function()
  require("mini.extra").pickers.manpages()
end, { desc = "Search man pages" })

map("n", "<leader>ss", function()
  require("mini.extra").pickers.lsp({ scope = "document_symbol" })
end, { desc = "Document LSP Symbols" })

map("n", "<leader>sS", function()
  require("mini.extra").pickers.lsp({ scope = "workspace_symbol" })
end, { desc = "Workspace LSP Symbols" })

map("n", "<leader>sc", function()
  require("mini.extra").pickers.history()
end, { desc = "Command History" })

map("n", "<leader>sD", function()
  require("mini.extra").pickers.spellsuggest()
end, { desc = "Suggest Spelling" })

map("n", "<leader>se", function()
  require("mini.extra").pickers.explorer()
end, { desc = "File Explorer" })

map("n", "<leader>sw", function()
  require("mini.pick").builtin.grep({ pattern = vim.fn.expand("<cword>") })
end, { desc = "Grep Word" })

map("n", "<leader>sg", function()
  require("mini.pick").builtin.grep()
end, { desc = "Grep Word" })

map("n", "<leader>st", function()
  require("mini.pick").builtin.grep({ pattern = "TODO|Todo" })
end, { desc = "Grep Word" })

map("n", "<leader>sT", function()
  require("mini.pick").builtin.grep({ pattern = "TODO|FIXME|FIX|Todo|Fix|Fixme" })
end, { desc = "Grep Word" })

map("n", "<leader>sh", function()
  require("mini.pick").builtin.help()
end, { desc = "Search Help" })

map("n", "<leader>sk", function()
  require("mini.extra").pickers.keymaps()
end, { desc = "Search Keymaps" })

map("n", "<C-c>", function()
  local op = require("mini.comment").operator()
  return op .. "_"
end, { expr = true, desc = "Comment current line" })

map("x", "<C-c>", function()
  return require("mini.comment").operator()
end, { expr = true, desc = "Comment selection" })

map("n", "<leader>cf", function()
  require("mini.trailspace").trim()
end, { desc = "Trim Trailspaces" })

map("n", "<leader>cl", function()
  require("mini.trailspace").trim_last_lines()
end, { desc = "Trim last lines" })

map("n", "<leader>go", function()
  require("mini.diff").toggle_overlay(0)
end, { desc = "Toggle Diff Overlay" })

map("n", "<leader>gt", "<cmd>lua MiniGit.toggle()<cr>", { desc = "Git toggle tracking" })
map("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git toggle tracking" })
map("n", "<leader>ga", "<cmd>Git add --all<cr>", { desc = "Git add all" })
map("n", "<leader>gb", "<cmd>Git add %<cr>", { desc = "Git add buffer" })
map("n", "<leader>gp", "<cmd>Git push<cr>", { desc = "Git push" })
map({ "n", "x" }, "<leader>gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", { desc = "Show at cursor" })
