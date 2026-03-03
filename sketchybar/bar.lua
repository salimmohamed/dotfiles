local colors = require("colors")

sbar.bar({
  topmost = "window",
  height = 33,
  color = colors.bar.bg,
  padding_right = 10,
  padding_left = 10,
  corner_radius = 9,
  y_offset = 5,
  margin = 10,
  blur_radius = 20,
  border_width = 1,
  border_color = colors.bg2,
  shadow = true,
  position = "top",
  notch_width = 200,
})
