vim.filetype.add({
  filename = {
    ["vifmrc"] = "vim",
  },
  pattern = {
    [".*/ghostty/config"] = "ghostty",
    [".*/ghostty/config.ghostty"] = "ghostty",
    [".*/hypr/.+%.conf"] = "hyprlang",
    ["%.env%.[%w_.-]+"] = "sh",
  },
})

-- register filetypes
local register = vim.treesitter.language.register

register("bash", "kitty")
register("ini", "ghostty")
register("markdown", "livebook")
