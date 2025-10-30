-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Hide ALL diagnostic signs immediately on startup
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "" })
