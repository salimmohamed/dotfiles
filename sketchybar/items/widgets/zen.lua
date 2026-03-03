-- Zen mode: toggles drawing on/off for most items
-- Triggered by calendar click via "zen_toggle" event

sbar.add("event", "zen_toggle")

local zen_items = {
  "widgets.battery",
  "widgets.battery.bracket",
  "widgets.battery.padding",
  "widgets.wifi",
  "widgets.wifi.bracket",
  "widgets.wifi.padding",
  "widgets.volume1",
  "widgets.volume2",
  "widgets.volume.bracket",
  "widgets.volume.padding",
  "widgets.music.icon",
  "widgets.music.title",
  "widgets.music.controls",
  "widgets.music.bracket",
  "widgets.codexbar",
  "widgets.codexbar.bracket",
  "widgets.codexbar.padding",
  "widgets.ram",
  "widgets.ram.bracket",
  "widgets.ram.padding",
  "widgets.cpu",
  "widgets.cpu.bracket",
  "widgets.cpu.padding",
}

local zen_listener = sbar.add("item", {
  drawing = false,
  updates = true,
})

zen_listener:subscribe("zen_toggle", function(env)
  local zen_on = env.state == "on"
  for _, name in ipairs(zen_items) do
    sbar.set(name, { drawing = not zen_on })
  end
end)
