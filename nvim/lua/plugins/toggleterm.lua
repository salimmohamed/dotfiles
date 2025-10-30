-- toggleterm.nvim - Better terminal integration for LazyVim
-- Provides VSCode-like terminal split with Python runner
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    -- Terminal size - 35% of screen height (Claude Code style)
    size = function(term)
      if term.direction == "horizontal" then
        return math.floor(vim.o.lines * 0.35)
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
    -- Quick toggle with Ctrl+\
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    direction = "horizontal", -- Default to horizontal split
    close_on_exit = true,
    shell = vim.o.shell,
    auto_scroll = true,
    -- Window appearance
    float_opts = {
      border = "curved",
      winblend = 0,
    },
  },
  keys = {
    -- Python runner - Space+r runs current file in horizontal terminal
    {
      "<leader>r",
      function()
        local filetype = vim.bo.filetype
        local file = vim.fn.expand("%:p")
        local cmd

        -- Support different file types
        if filetype == "python" then
          cmd = "python3 " .. vim.fn.shellescape(file)
        elseif filetype == "javascript" or filetype == "typescript" then
          cmd = "node " .. vim.fn.shellescape(file)
        elseif filetype == "lua" then
          cmd = "lua " .. vim.fn.shellescape(file)
        elseif filetype == "sh" or filetype == "bash" then
          cmd = "bash " .. vim.fn.shellescape(file)
        elseif filetype == "zsh" then
          cmd = "zsh " .. vim.fn.shellescape(file)
        else
          vim.notify("No runner configured for filetype: " .. filetype, vim.log.levels.WARN)
          return
        end

        -- Execute in terminal 1, horizontal split, 35% height
        local size = math.floor(vim.o.lines * 0.35)
        require("toggleterm").exec(cmd, 1, size, nil, "horizontal")
      end,
      desc = "Run current file in terminal",
    },

    -- Terminal toggles
    {
      "<leader>th",
      function()
        local size = math.floor(vim.o.lines * 0.35)
        vim.cmd("ToggleTerm direction=horizontal size=" .. size)
      end,
      desc = "Toggle horizontal terminal",
    },
    {
      "<leader>tv",
      "<cmd>ToggleTerm direction=vertical<cr>",
      desc = "Toggle vertical terminal",
    },
    {
      "<leader>tf",
      "<cmd>ToggleTerm direction=float<cr>",
      desc = "Toggle floating terminal",
    },

    -- Terminal navigation in terminal mode
    -- Double Escape to exit terminal mode
    {
      "<Esc><Esc>",
      [[<C-\><C-n>]],
      mode = "t",
      desc = "Exit terminal mode",
    },
  },
}
