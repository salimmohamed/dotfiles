-- lua/plugins/obsidian.lua
return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    -- Daily notes
    { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Open today's note" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Open yesterday's note" },
    { "<leader>om", "<cmd>ObsidianTomorrow<cr>", desc = "Open tomorrow's note" },
    {
      "<leader>od",
      function()
        local regimen_folder = vim.fn.expand("~/Learn/Notes/Main/7 - Daily Regimen")
        local leetcode_folder = vim.fn.expand("~/Learn/Notes/Main/2 - Source Material/Leetcode")
        local date_format = os.date("%B %d %Y")
        local regimen_file = regimen_folder .. "/" .. date_format .. ".md"
        local leetcode_file = leetcode_folder .. "/" .. date_format .. ".md"

        -- Create folders if they don't exist
        vim.fn.mkdir(regimen_folder, "p")
        vim.fn.mkdir(leetcode_folder, "p")

        -- If leetcode note doesn't exist, create it with template
        if vim.fn.filereadable(leetcode_file) == 0 then
          vim.cmd("edit " .. leetcode_file)
          vim.cmd("ObsidianTemplate Leetcode")
          vim.cmd("write")
        end

        -- Open/create the regimen file
        vim.cmd("edit " .. regimen_file)

        -- If file is new, insert template
        if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' then
          vim.cmd("ObsidianTemplate DailyRegimen")
        end
      end,
      desc = "Open daily regimen"
    },
    {
      "<leader>oD",
      function()
        local regimen_folder = vim.fn.expand("~/Learn/Notes/Main/7 - Daily Regimen")
        local leetcode_folder = vim.fn.expand("~/Learn/Notes/Main/2 - Source Material/Leetcode")
        -- Calculate tomorrow's date (current time + 24 hours)
        local tomorrow = os.time() + (24 * 60 * 60)
        local date_format = os.date("%B %d %Y", tomorrow)
        local regimen_file = regimen_folder .. "/" .. date_format .. ".md"
        local leetcode_file = leetcode_folder .. "/" .. date_format .. ".md"

        -- Create folders if they don't exist
        vim.fn.mkdir(regimen_folder, "p")
        vim.fn.mkdir(leetcode_folder, "p")

        -- If tomorrow's leetcode note doesn't exist, create it with template
        if vim.fn.filereadable(leetcode_file) == 0 then
          vim.cmd("edit " .. leetcode_file)
          vim.cmd("ObsidianTemplate Leetcode")
          vim.cmd("write")
        end

        -- Open/create tomorrow's regimen file
        vim.cmd("edit " .. regimen_file)

        -- If file is new, insert template
        if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' then
          vim.cmd("ObsidianTemplate DailyRegimen")
        end
      end,
      desc = "Open tomorrow's daily regimen"
    },

    -- Note management
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Create new note" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
    { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch notes" },
    { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Show links" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show backlinks" },

    -- Templates
    { "<leader>oT", "<cmd>ObsidianTemplate<cr>", desc = "Insert template" },
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    -- Suppress errors and warnings
    log_level = vim.log.levels.ERROR,
    workspaces = {
      {
        name = "main",
        path = vim.fn.expand("~/Learn/Notes/Main"),
      },
    },
    
    -- Daily notes configuration
    daily_notes = {
      folder = "2 - Source Material/Leetcode",
      date_format = "%B %d %Y", -- Format: "October 29 2025"
      alias_format = "%B %-d, %Y",
      default_tags = { "leetcode", "daily-notes" },
      template = "Leetcode.md", -- Use your Leetcode template
    },

    -- Templates configuration
    templates = {
      folder = "5 - Templates",
      date_format = "%B %d %Y", -- Match daily notes format
      time_format = "%H:%M",
      substitutions = {
        -- These will be available in your template as {{date}}, {{time}}, {{Title}}
        date = function()
          return os.date("%B %d %Y")
        end,
        time = function()
          return os.date("%H:%M")
        end,
        Title = function()
          return os.date("%B %d %Y")
        end,
      },
    },
    
    -- Completion with blink.cmp (since you use that)
    completion = {
      nvim_cmp = false, -- You use blink.cmp instead
      min_chars = 2,
    },
    
    -- New note configuration
    new_notes_location = "notes_subdir",
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        suffix = tostring(os.time())
      end
      return suffix
    end,
    
    -- Wiki links configuration
    wiki_link_func = "use_alias_only",
    
    -- Open URLs in external browser
    follow_url_func = function(url)
      vim.fn.jobstart({"open", url})  -- macOS
    end,
    
    -- UI enhancements
    ui = {
      enable = true,
      update_debounce = 200,
      max_file_length = 5000,
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
    },
    
    -- Checkbox order
    checkbox_order = { " ", "x", ">", "~", "!" },
    
    -- Disable frontmatter - return nil to prevent adding YAML metadata
    note_frontmatter_func = function(note)
          return nil -- Could result in invalid assignment if not nil
    end,

    -- Disable auto-formatting and frontmatter
    disable_frontmatter = true,
  },
}
