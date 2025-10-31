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

        -- Store the original window to return to after process exits
        local origin_win = vim.api.nvim_get_current_win()

        -- Get or create terminal 1 with on_exit callback
        local Terminal = require("toggleterm.terminal").Terminal
        local term = require("toggleterm.terminal").get(1)

        if not term then
          -- Create terminal 1 with on_exit callback
          term = Terminal:new({
            id = 1,
            direction = "horizontal",
            on_exit = function()
              -- Return focus to original window when process exits
              vim.schedule(function()
                -- Only switch if:
                -- 1. Origin window is still valid
                -- 2. We're not in the middle of another operation
                -- 3. The current mode allows window switching
                if vim.api.nvim_win_is_valid(origin_win) then
                  local current_win = vim.api.nvim_get_current_win()
                  -- Only switch if we're still in a terminal or the terminal window
                  local current_buf = vim.api.nvim_win_get_buf(current_win)
                  if vim.bo[current_buf].buftype == "terminal" or current_win == term.window then
                    pcall(vim.api.nvim_set_current_win, origin_win)
                  end
                end
              end)
            end,
          })
        else
          -- Update existing terminal's on_exit callback
          term.on_exit = function()
            vim.schedule(function()
              -- Only switch if:
              -- 1. Origin window is still valid
              -- 2. We're not in the middle of another operation
              -- 3. The current mode allows window switching
              if vim.api.nvim_win_is_valid(origin_win) then
                local current_win = vim.api.nvim_get_current_win()
                -- Only switch if we're still in a terminal or the terminal window
                local current_buf = vim.api.nvim_win_get_buf(current_win)
                if vim.bo[current_buf].buftype == "terminal" or current_win == term.window then
                  pcall(vim.api.nvim_set_current_win, origin_win)
                end
              end
            end)
          end
        end

        -- Clear and run the command, wait 10s (or Enter to skip), then exit
        local size = math.floor(vim.o.lines * 0.35)
        -- Add 10s timer before exit - press Enter to skip and return immediately
        -- Use curly braces to group commands and ensure they all execute
        local clear_and_run = "clear && { " .. cmd .. "; echo ''; echo 'Press Enter to return (or wait 10s)...'; read -t 10 || true; }; exit"

        -- Open terminal if not visible, then send command
        if not term:is_open() then
          term:open(size, "horizontal")
        end

        -- Send the command to the terminal
        term:send(clear_and_run)

        -- Focus terminal and enter insert mode after a short delay
        vim.defer_fn(function()
          if term:is_open() and term.window then
            -- Focus the terminal window
            vim.api.nvim_set_current_win(term.window)
            -- Enter insert mode
            vim.cmd("startinsert")
          end
        end, 50)
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
