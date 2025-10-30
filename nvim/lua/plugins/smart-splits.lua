-- Smart splits for seamless navigation between tmux/wezterm and neovim
return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  keys = {
    -- Navigation (works in normal mode and with WezTerm)
    { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left split" },
    { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to below split" },
    { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to above split" },
    { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right split" },

    -- Navigation in terminal mode
    { "<C-h>", [[<Cmd>wincmd h<CR>]], mode = "t", desc = "Move to left split (terminal)" },
    { "<C-j>", [[<Cmd>wincmd j<CR>]], mode = "t", desc = "Move to below split (terminal)" },
    { "<C-k>", [[<Cmd>wincmd k<CR>]], mode = "t", desc = "Move to above split (terminal)" },
    { "<C-l>", [[<Cmd>wincmd l<CR>]], mode = "t", desc = "Move to right split (terminal)" },

    -- Resizing (CMD+ALT+hjkl on Mac - avoids AeroSpace conflict)
    { "<D-A-h>", function() require("smart-splits").resize_left() end, desc = "Resize split left" },
    { "<D-A-j>", function() require("smart-splits").resize_down() end, desc = "Resize split down" },
    { "<D-A-k>", function() require("smart-splits").resize_up() end, desc = "Resize split up" },
    { "<D-A-l>", function() require("smart-splits").resize_right() end, desc = "Resize split right" },
  },
  opts = {
    -- Ignore filetrees and other UI panels
    ignored_filetypes = {
      "nofile",
      "quickfix",
      "qf",
      "prompt",
    },
    ignored_buftypes = {
      "nofile",
      "terminal",
      "prompt",
    },
    -- Wrap around edges when navigating between splits
    at_edge = "wrap",
  },
}
