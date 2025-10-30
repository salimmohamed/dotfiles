-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Create a user command to clear all Obsidian vault diagnostics
vim.api.nvim_create_user_command("ObsidianClearDiagnostics", function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname:match("/Documents/Notes/Main/") and bufname:match("%.md$") then
      vim.diagnostic.reset(nil, buf)
      vim.diagnostic.enable(false, { bufnr = buf })
    end
  end
  print("Cleared all Obsidian vault diagnostics")
end, {})

-- Disable ALL diagnostics for Obsidian vault markdown files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufEnter" }, {
  pattern = { "*/Documents/Notes/Main/*.md", "*/Documents/Notes/Main/**/*.md" },
  callback = function(args)
    -- Disable diagnostics completely for this buffer
    vim.diagnostic.enable(false, { bufnr = args.buf })

    -- Clear any existing diagnostics
    vim.diagnostic.reset(nil, args.buf)
  end,
})
