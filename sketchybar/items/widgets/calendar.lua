local settings = require("settings")
local colors = require("colors")

local cal_time = sbar.add("item", "widgets.calendar.time", {
  position = "right",
  icon = { drawing = false },
  label = {
    color = colors.white,
    padding_right = 8,
    padding_left = 2.5,
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 12.0,
    },
  },
  padding_left = 0,
  padding_right = 0,
  update_freq = 30,
  background = { drawing = false },
})

local cal_date = sbar.add("item", "widgets.calendar.date", {
  position = "right",
  icon = { drawing = false },
  label = {
    color = colors.white,
    padding_left = 8,
    padding_right = 2.5,
    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    },
  },
  padding_left = 0,
  padding_right = 0,
  background = { drawing = false },
})

sbar.add("bracket", "widgets.calendar.bracket", {
  cal_date.name,
  cal_time.name,
}, {
  background = {
    color = colors.bg1,
    border_color = colors.bg2,
    border_width = 1,
  },
})

sbar.add("item", "widgets.calendar.padding", {
  position = "right",
  width = settings.group_paddings,
})

cal_time:subscribe({"forced", "routine", "system_woke"}, function(env)
  cal_time:set({ label = os.date("%I:%M %p"):lower() })
  cal_date:set({ label = os.date("%a %d %b") })
end)

local zen_on = false
cal_time:subscribe("mouse.clicked", function(env)
  zen_on = not zen_on
  sbar.trigger("zen_toggle", { state = zen_on and "on" or "off" })
end)
cal_date:subscribe("mouse.clicked", function(env)
  zen_on = not zen_on
  sbar.trigger("zen_toggle", { state = zen_on and "on" or "off" })
end)
