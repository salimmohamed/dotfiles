local wezterm = require('wezterm')

local M = {}

local function clean_process_name(proc)
   if not proc then
      return ''
   end
   local name = proc:match('([^/\\]+)$')
   return name:gsub('%.exe$', '')
end

M.setup = function()
   -- Custom event: Manually update tab title
   wezterm.on('tabs.manual-update-tab-title', function(window, pane)
      window:perform_action(
         wezterm.action.PromptInputLine({
            description = 'Enter new tab title:',
            action = wezterm.action_callback(function(win, _, line)
               if line then
                  win:active_tab():set_title(line)
               end
            end),
         }),
         pane
      )
   end)

   -- Custom event: Reset tab title
   wezterm.on('tabs.reset-tab-title', function(window, _)
      window:active_tab():set_title('')
   end)

   -- Custom event: Toggle tab bar visibility
   wezterm.on('tabs.toggle-tab-bar', function(window, _)
      local overrides = window:get_config_overrides() or {}
      if overrides.enable_tab_bar == false then
         overrides.enable_tab_bar = true
      else
         overrides.enable_tab_bar = false
      end
      window:set_config_overrides(overrides)
   end)

   -- Format tab title
   wezterm.on('format-tab-title', function(tab, _, _, _, _, max_width)
      local title = tab.tab_title
      local pane = tab.active_pane

      -- If no custom title, use process name and pane title
      if not title or #title == 0 then
         local process = clean_process_name(pane.foreground_process_name)
         if process and #process > 0 then
            title = process
         else
            title = pane.title
         end
      end

      -- Truncate if needed
      if #title > max_width - 4 then
         title = title:sub(1, max_width - 7) .. '...'
      end

      -- Add padding and tab index
      local index = tab.tab_index + 1
      return string.format(' %d: %s ', index, title)
   end)
end

return M
