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

-- Query the Claude provider explicitly; `codexbar --json` returns every enabled
-- provider (codex, claude, copilot, ...) so indexing .[0] is not reliable.
local usage_cmd = [[codexbar usage --provider claude --json 2>/dev/null | jq -r '
  map(select(.provider == "claude"))[0]
  | if .usage then "\(.usage.primary.usedPercent // 0 | round) \(.usage.secondary.usedPercent // 0 | round)"
    else "ERR" end' 2>/dev/null]]

codexbar:subscribe({"routine", "forced", "system_woke"}, function()
  sbar.exec(usage_cmd, function(result)
    local p5, p7 = tostring(result):match("^(%d+)%s+(%d+)")
    if not (p5 and p7) then
      codexbar:set({
        label = { string = "n/a", color = colors.grey },
        icon = { color = colors.grey },
      })
      return
    end

    p5, p7 = tonumber(p5), tonumber(p7)
    local color = get_color_for_pct(math.max(p5, p7))
    codexbar:set({
      label = { string = "5h:" .. p5 .. "%  7d:" .. p7 .. "%", color = color },
      icon = { color = color },
    })
  end)
end)

codexbar:subscribe("mouse.clicked", function(env)
  sbar.exec([[osascript -e 'tell application "System Events" to tell process "CodexBar" to click menu bar item 1 of menu bar 2']])
end)
