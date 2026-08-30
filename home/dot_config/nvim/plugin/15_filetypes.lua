local function match_template(path, bufnr)
  local filename = path:gsub("%.tmpl$", "")
  local args = { filename = filename }

  if bufnr >= 0 then
    args.buf = bufnr
  end

  return vim.filetype.match(args)
end

vim.filetype.add({
  filename = {
    ["vifmrc"] = "vim",
  },
  pattern = {
    [".*/bat/config%.tmpl"] = { "conf", { priority = 10 } },
    [".*/ghostty/config"] = "ghostty",
    [".*/ghostty/config.ghostty"] = "ghostty",
    [".*/git/config%.tmpl"] = { "gitconfig", { priority = 10 } },
    [".*/hypr/.+%.conf"] = "hyprlang",
    ["%.env%.[%w_.-]+"] = "sh",
    [".+%.jjdescription"] = "gitcommit",
    [".+%.tmpl"] = match_template,
  },
})

-- register filetypes
local register = vim.treesitter.language.register

register("bash", "kitty")
register("ini", "ghostty")
register("markdown", "livebook")
