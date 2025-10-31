local wezterm = require('wezterm')
local mux = wezterm.mux

local M = {}

-- Helper function to check if a workspace exists
local function workspace_exists(workspace_name)
   local workspaces = mux.get_workspace_names()
   for _, name in ipairs(workspaces) do
      if name == workspace_name then
         return true
      end
   end
   return false
end

M.setup = function()
   -- Use mux-startup for workspace creation (fires when mux server starts)
   -- This event fires BEFORE gui-startup and works with 'wezterm connect'
   wezterm.on('mux-startup', function()
      -- Define our three desired workspaces
      local desired_workspaces = {
         {
            name = 'school',
            cwd = '/Users/sm/Learn',
         },
         {
            name = 'dev',
            cwd = wezterm.home_dir .. '/dev',
         },
         {
            name = 'obsidian',
            cwd = '/Users/sm/Learn/Notes/Main',
         },
      }

      -- Create each workspace only if it doesn't exist
      for _, workspace in ipairs(desired_workspaces) do
         if not workspace_exists(workspace.name) then
            mux.spawn_window({
               workspace = workspace.name,
               cwd = workspace.cwd,
            })
         end
      end

      -- Set school as the active workspace
      mux.set_active_workspace('school')
   end)

   -- Use gui-attached for GUI operations like maximizing
   -- This fires when the GUI connects to a domain
   wezterm.on('gui-attached', function(domain)
      -- Maximize the window when GUI attaches
      local workspace = mux.get_active_workspace()
      for _, window in ipairs(mux.all_windows()) do
         if window:get_workspace() == workspace then
            local gui_win = window:gui_window()
            if gui_win then
               gui_win:maximize()
            end
            break
         end
      end
   end)
end

return M
