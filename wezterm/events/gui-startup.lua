local wezterm = require('wezterm')
local mux = wezterm.mux

local M = {}

M.setup = function()
   wezterm.on('gui-startup', function(cmd)
      -- Check if we already have workspaces (resuming existing session)
      local workspaces = mux.get_workspace_names()

      -- If only default workspace exists, this is likely first launch
      -- Create our three persistent workspaces
      if #workspaces == 1 and workspaces[1] == 'default' then
         -- Create 'dev' workspace
         local dev_tab, dev_pane, dev_window = mux.spawn_window({
            workspace = 'dev',
            cwd = wezterm.home_dir .. '/projects',
         })
         dev_window:gui_window():maximize()

         -- Create 'school' workspace
         local school_tab, school_pane, school_window = mux.spawn_window({
            workspace = 'school',
            cwd = wezterm.home_dir .. '/school',
         })
         school_window:gui_window():maximize()

         -- Create 'obsidian' workspace
         local obs_tab, obs_pane, obs_window = mux.spawn_window({
            workspace = 'obsidian',
            cwd = wezterm.home_dir .. '/obsidian',
         })
         obs_window:gui_window():maximize()

         -- Switch to dev workspace as the default
         mux.set_active_workspace('dev')
      else
         -- Resuming existing session - just spawn in current workspace
         local _, _, window = mux.spawn_window(cmd or {})
         window:gui_window():maximize()
      end
   end)
end

return M
