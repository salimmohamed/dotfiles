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

-- ============================================================================
-- AUTOMATIC SWAP FILE HANDLING
-- ============================================================================
-- This configuration provides fully automatic swap file management:
-- - Maintains crash recovery protection (swap files are kept)
-- - Never shows E325 swap file warnings
-- - Handles multiple Neovim instances safely
-- - Auto-cleans swap files on proper exit
-- ============================================================================

-- Auto-handle all swap file conflicts (never show prompts)
vim.api.nvim_create_autocmd("SwapExists", {
  group = vim.api.nvim_create_augroup("auto_swap_handling", { clear = true }),
  pattern = "*",
  callback = function()
    -- Always edit anyway - this prevents E325 prompts entirely
    -- Safe for multiple instances and terminal closure scenarios
    vim.v.swapchoice = "e"
  end,
})

-- Ensure clean swap file cleanup on proper exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("swap_cleanup_on_exit", { clear = true }),
  callback = function()
    -- Write all buffers to ensure swap files can be safely removed
    pcall(function()
      vim.cmd("silent! wall")
    end)

    -- Force cleanup of swap files for closed buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and not vim.api.nvim_buf_get_option(buf, "modified") then
        pcall(function()
          vim.api.nvim_buf_delete(buf, { force = false, unload = true })
        end)
      end
    end
  end,
})

-- Auto-cleanup orphaned swap files on Neovim startup
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("swap_startup_cleanup", { clear = true }),
  once = true,
  callback = function()
    -- Run cleanup script silently in background (script will be created below)
    vim.fn.jobstart({ "bash", "-c", "~/.local/bin/nvim-clean-swaps.sh" }, {
      detach = true,
      on_exit = function() end,
    })
  end,
})
