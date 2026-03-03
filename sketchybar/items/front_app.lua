local colors = require("colors")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
  display = "active",
  icon = {
    drawing = true,
    font = {
      style = settings.font.style_map["Regular"],
      size = 16.0,
    },
    padding_right = 4,
  },
  label = {
    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    },
    color = colors.white,
  },
  padding_left = 2,
  updates = true,
})

front_app:subscribe("front_app_switched", function(env)
  front_app:set({
    label = { string = env.INFO },
    icon = { background = { image = { string = "app." .. env.INFO, scale = 0.7 } } },
  })
end)
