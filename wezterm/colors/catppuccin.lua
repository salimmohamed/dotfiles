-- Catppuccin Mocha color scheme
-- https://github.com/catppuccin/catppuccin

local mocha = {
   rosewater = '#f5e0dc',
   flamingo  = '#f2cdcd',
   pink      = '#f5c2e7',
   mauve     = '#cba6f7',
   red       = '#f38ba8',
   maroon    = '#eba0ac',
   peach     = '#fab387',
   yellow    = '#f9e2af',
   green     = '#a6e3a1',
   teal      = '#94e2d5',
   sky       = '#89dceb',
   sapphire  = '#74c7ec',
   blue      = '#89b4fa',
   lavender  = '#b4befe',
   text      = '#cdd6f4',
   subtext1  = '#bac2de',
   subtext0  = '#a6adc8',
   overlay2  = '#9399b2',
   overlay1  = '#7f849c',
   overlay0  = '#6c7086',
   surface2  = '#585b70',
   surface1  = '#45475a',
   surface0  = '#313244',
   base      = '#1e1e2e',
   mantle    = '#181825',
   crust     = '#11111b',
}

local colorscheme = {
   foreground = mocha.text,
   background = mocha.base,
   cursor_bg = mocha.rosewater,
   cursor_border = mocha.rosewater,
   cursor_fg = mocha.crust,
   selection_bg = mocha.surface2,
   selection_fg = mocha.text,

   -- Terminal colors
   ansi = {
      mocha.surface1,  -- black
      mocha.red,       -- red
      mocha.green,     -- green
      mocha.yellow,    -- yellow
      mocha.blue,      -- blue
      mocha.pink,      -- magenta
      mocha.teal,      -- cyan
      mocha.subtext1,  -- white
   },
   brights = {
      mocha.surface2,  -- bright black
      mocha.red,       -- bright red
      mocha.green,     -- bright green
      mocha.yellow,    -- bright yellow
      mocha.blue,      -- bright blue
      mocha.pink,      -- bright magenta
      mocha.teal,      -- bright cyan
      mocha.subtext0,  -- bright white
   },

   -- Tab bar colors
   tab_bar = {
      background = mocha.crust,
      active_tab = {
         bg_color = mocha.surface2,
         fg_color = mocha.text,
         intensity = 'Bold',
      },
      inactive_tab = {
         bg_color = mocha.surface0,
         fg_color = mocha.subtext0,
      },
      inactive_tab_hover = {
         bg_color = mocha.surface1,
         fg_color = mocha.text,
      },
      new_tab = {
         bg_color = mocha.base,
         fg_color = mocha.text,
      },
      new_tab_hover = {
         bg_color = mocha.mantle,
         fg_color = mocha.text,
         italic = true,
      },
   },

   -- Additional colors
   visual_bell = mocha.red,
   indexed = {
      [16] = mocha.peach,
      [17] = mocha.rosewater,
   },
   scrollbar_thumb = mocha.surface2,
   split = mocha.overlay0,
   compose_cursor = mocha.flamingo,
}

return colorscheme
