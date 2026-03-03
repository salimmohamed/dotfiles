local colors = require("colors")
local settings = require("settings")

local codexbar = sbar.add("item", "widgets.codexbar", {
  position = "right",
  icon = {
    string = "􁜅",
    font = { size = 14.0 },
    color = colors.cyan,
  },
  label = {
    string = "...",
    font = {
      family = settings.font.numbers,
      size = 11.0,
    },
    color = colors.cyan,
  },
  update_freq = 120,
})

sbar.add("bracket", "widgets.codexbar.bracket", { codexbar.name }, {
  background = { color = colors.bg1 },
})

sbar.add("item", "widgets.codexbar.padding", {
  position = "right",
  width = settings.group_paddings,
})

local function get_color_for_pct(pct)
  if pct >= 80 then return colors.red end
  if pct >= 60 then return colors.yellow end
  return colors.cyan
end

codexbar:subscribe({"routine", "forced", "system_woke"}, function()
  sbar.exec([[codexbar --json 2>/dev/null | head -1 | jq -r '.[0].usage | "\(.primary.usedPercent) \(.secondary.usedPercent)"' 2>/dev/null]], function(result)
    if result == "" or result == "null null\n" then
      codexbar:set({ label = { string = "n/a", color = colors.grey } })
      return
    end

    local p5, p7 = result:match("(%d+)%s+(%d+)")
    if p5 and p7 then
      p5 = tonumber(p5)
      p7 = tonumber(p7)
      local label = "5h:" .. p5 .. "%  7d:" .. p7 .. "%"
      local max_pct = math.max(p5, p7)

      codexbar:set({
        label = {
          string = label,
          color = get_color_for_pct(max_pct),
        },
        icon = { color = get_color_for_pct(max_pct) },
      })
    else
      codexbar:set({ label = { string = "err", color = colors.red } })
    end
  end)
end)

codexbar:subscribe("mouse.clicked", function(env)
  sbar.exec([[osascript -e 'tell application "System Events" to tell process "CodexBar" to click menu bar item 1 of menu bar 2']])
end)
