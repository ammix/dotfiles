-- Built-in plugins
vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")

-- Oil
require("oil").setup({
  columns = {
    "permissions",
    "size",
    "mtime",
    "icon",
  },
  hidden = true,
  watch_for_changes = true,
  view_options = { show_hidden = true },
  keymaps = {
    ["gX"] = {
      desc = "Make file executable",
      callback = function()
        local oil = require("oil")
        local entry = oil.get_cursor_entry()
        if not entry then
          return
        end
        local dir = oil.get_current_dir()
        if not dir then
          return
        end
        vim.system({ "chmod", "+x", dir .. entry.name }, {}, function(result)
          if result.code == 0 then
            vim.schedule(function()
              vim.notify("chmod +x " .. entry.name)
            end)
          end
        end)
      end,
    },
  },
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Typst
require("typst-preview").setup({})

-- Leap
require("leap").opts.preview = function(ch0, ch1, ch2)
  return not (ch1:match("%s") or (ch0:match("%a") and ch1:match("%a") and ch2:match("%a")))
end
require("leap").opts.equivalence_classes = {
  " \t\r\n",
  "([{",
  ")]}",
  "'\"`",
}
require("leap.user").set_repeat_keys("<enter>", "<backspace>")

-- Keymaps
local map = vim.keymap.set
map({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap" })
map("n", "S", "<Plug>(leap-from-window)", { desc = "Leap from window" })
map("o", "gr", function()
  require("leap.remote").action({
    input = vim.fn.mode(true):match("o") and "" or "v",
  })
end)
