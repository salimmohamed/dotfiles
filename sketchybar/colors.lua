-- Colors come from the master theme in ~/.config/theme. Switch with `theme <name>`.
local p = dofile(os.getenv("HOME") .. "/.config/theme/generated/sketchybar.lua")

local function alpha(color, a)
  return (color & 0x00ffffff) | (a << 24)
end

return {
  palette = p,

  black = p.base,
  white = p.text,
  dim = p.subtext0, -- secondary text (Tokyo Night fg_dark)
  red = p.red,
  green = p.green,
  blue = p.blue,
  yellow = p.yellow,
  orange = p.peach,
  magenta = p.mauve,
  cyan = p.teal,
  grey = p.overlay0,
  transparent = 0x00000000,

  bar = {
    bg = alpha(p.base, 0xcc),
  },
  popup = {
    bg = alpha(p.base, 0xcc),
    border = p.surface1,
  },
  bg1 = p.surface0,
  bg2 = p.surface1,

  with_alpha = function(color, a)
    if a > 1.0 or a < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(a * 255.0) << 24)
  end,
}
