local wezterm = require('wezterm')
local mux = wezterm.mux

local M = {}

M.setup = function()
   wezterm.on('gui-startup', function(cmd)
      -- Spawn window
      local _, _, window = mux.spawn_window(cmd or {})

      -- Maximize window on startup
      window:gui_window():maximize()
   end)
end

return M
