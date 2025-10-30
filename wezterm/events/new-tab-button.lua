local wezterm = require('wezterm')

local M = {}

M.setup = function()
   wezterm.on('new-tab-button-click', function(window, pane, button, default_action)
      if button == 'Left' and default_action then
         -- Left click: spawn new tab
         window:perform_action(default_action, pane)
      elseif button == 'Right' then
         -- Right click: show launcher
         window:perform_action(wezterm.action.ShowLauncher, pane)
      end
      return false
   end)
end

return M
