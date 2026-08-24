local blink_cmp = require("blink.cmp")

blink_cmp.build():pwait()
blink_cmp.setup({
  snippets = { preset = "mini_snippets" },
  signature = { enabled = true },
  cmdline = { enabled = false },
})
