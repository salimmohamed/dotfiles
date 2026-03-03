local colors = require("colors")
local settings = require("settings")

local ram = sbar.add("graph", "widgets.ram", 42, {
  position = "right",
  graph = { color = colors.cyan },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = { string = "􀫦" },
  label = {
    string = "ram ??%",
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4,
  },
  update_freq = 4,
  padding_right = settings.paddings + 6,
})

ram:subscribe({"routine", "forced", "system_woke"}, function()
  sbar.exec([[vm_stat | awk '
    /Pages active/ {a=$3}
    /Pages wired/ {w=$4}
    /Pages compressed/ {c=$5}
    /Pages free/ {f=$3}
    /Pages inactive/ {i=$3}
    /Pages speculative/ {s=$3}
    END {
      gsub(/\./,"",a); gsub(/\./,"",w); gsub(/\./,"",c);
      gsub(/\./,"",f); gsub(/\./,"",i); gsub(/\./,"",s);
      used = (a+w+c) * 4096;
      total = (a+w+c+f+i+s) * 4096;
      if (total > 0) printf("%.0f\n", used/total*100);
      else print "0";
    }']], function(result)
    local pct = tonumber(result) or 0
    ram:push({ pct / 100. })

    local color = colors.cyan
    if pct > 80 then
      color = colors.red
    elseif pct > 60 then
      color = colors.yellow
    end

    ram:set({
      graph = { color = color },
      label = "ram " .. pct .. "%",
    })
  end)
end)

ram:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Activity Monitor'")
end)

sbar.add("bracket", "widgets.ram.bracket", { ram.name }, {
  background = { color = colors.bg1 },
})

sbar.add("item", "widgets.ram.padding", {
  position = "right",
  width = settings.group_paddings,
})
