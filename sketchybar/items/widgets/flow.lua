local colors = require("colors")
local settings = require("settings")

local flow = sbar.add("item", "widgets.flow", {
  position = "right",
  update_freq = 1,
  icon = {
    string = "F",
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Bold"],
      size = 8.0,
    },
    y_offset = -4,
    color = colors.white,
  },
  label = {
    string = "--:--",
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 12.0,
    },
    y_offset = 4,
    color = colors.white,
  },
  padding_right = settings.paddings,
})

local flow_bracket = sbar.add("bracket", "widgets.flow.bracket", { flow.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.flow.padding", {
  position = "right",
  width = settings.group_paddings
})

local last_time = ""
local is_running = false

local function update_flow()
  sbar.exec("pgrep -x Flow", function(pid)
    if pid == "" then
      flow:set({ drawing = false })
      flow_bracket:set({ drawing = false })
      return
    end

    sbar.exec("osascript -e 'tell application \"Flow\" to getTime' 2>/dev/null", function(time)
      if time == "" then
        flow:set({ drawing = false })
        flow_bracket:set({ drawing = false })
        return
      end

      local clean_time = time:gsub("%s+", "")

      -- Detect if timer is running by checking if time changed
      if clean_time ~= last_time and last_time ~= "" then
        is_running = true
      elseif clean_time == last_time and last_time ~= "" then
        is_running = false
      end
      last_time = clean_time

      sbar.exec("osascript -e 'tell application \"Flow\" to getPhase' 2>/dev/null", function(phase)
        local phase_letter = "F"
        local phase_color = colors.red

        if phase and phase:match("Break") then
          phase_letter = "B"
          phase_color = colors.green
        end

        flow:set({
          drawing = true,
          label = { string = clean_time },
          icon = {
            string = phase_letter,
            color = phase_color,
          },
        })
        flow_bracket:set({ drawing = true })
      end)
    end)
  end)
end

flow:subscribe({"routine", "forced", "system_woke"}, update_flow)

flow:subscribe("mouse.clicked", function(env)
  if env.BUTTON == "right" then
    sbar.exec("open -a 'Flow'")
  else
    -- Left click toggles start/stop
    if is_running then
      sbar.exec("osascript -e 'tell application \"Flow\" to stop'")
    else
      sbar.exec("osascript -e 'tell application \"Flow\" to start'")
    end
  end
end)

-- Trigger initial update
update_flow()
