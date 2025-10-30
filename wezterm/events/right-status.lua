local wezterm = require('wezterm')

local M = {}

M.setup = function()
   wezterm.on('update-right-status', function(window, pane)
      local status_items = {}

      -- Leader indicator
      if window:leader_is_active() then
         table.insert(status_items, 'LEADER')
      end

      -- Workspace name
      local workspace = window:active_workspace()
      if workspace and workspace ~= 'default' then
         table.insert(status_items, '[' .. workspace .. ']')
      end

      -- Active process
      local process_name = pane:get_foreground_process_name()
      if process_name then
         process_name = process_name:match('([^/\\]+)$') -- Get basename
         process_name = process_name:gsub('%.exe$', '') -- Remove .exe on Windows
         table.insert(status_items, process_name)
      end

      -- Pane and tab counts
      local tab = window:active_tab()
      if tab then
         local pane_count = #tab:panes()
         local tab_count = #window:mux_window():tabs()

         table.insert(status_items, string.format('panes:%d tabs:%d', pane_count, tab_count))
      end

      -- Set the status with items separated by ' | '
      window:set_right_status(table.concat(status_items, ' | '))
   end)
end

return M
