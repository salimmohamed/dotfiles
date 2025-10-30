local wezterm = require('wezterm')
local platform = require('utils.platform')

local font_family = 'JetBrainsMono Nerd Font'
local font_size = platform.is_mac and 16 or 12

return {
   font = wezterm.font({
      family = font_family,
      weight = 'Regular',
   }),
   font_size = font_size,

   -- Font rendering settings
   freetype_load_target = 'Normal',
   freetype_render_target = 'Normal',
}
