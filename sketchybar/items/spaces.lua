local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

local space_ids = { "1", "2", "3", "4", "C" }

-- Uncomment to enable workspaces 5-8
-- local space_ids = { "1", "2", "3", "4", "C", "5", "6", "7", "8" }

local space_icons = {
  ["1"] = "􀪏",  -- terminal
  ["2"] = "􀎬",  -- compass/browser
  ["3"] = "􀈎",  -- notes
  ["4"] = "􀌲",  -- message
  ["C"] = "􀤙",  -- code
  -- ["5"] = "􀑪",  -- music
  -- ["6"] = "􀈕",  -- folder
  -- ["7"] = "􀙗",  -- design
  -- ["8"] = "􀍟",  -- gear
}

local space_colors = {
  ["1"] = colors.blue,
  ["2"] = colors.green,
  ["3"] = colors.magenta,
  ["4"] = colors.yellow,
  ["C"] = colors.cyan,
  -- ["5"] = colors.orange,
  -- ["6"] = colors.cyan,
  -- ["7"] = colors.red,
  -- ["8"] = colors.grey,
}

local display_space_map = {}
for _, id in ipairs(space_ids) do
  display_space_map[id] = "1"
end

for _, i in ipairs(space_ids) do
  local space = sbar.add("space", "space." .. i, {
    space = display_space_map[i],
    icon = {
      font = { family = settings.font.text, size = 14.0 },
      string = space_icons[i],
      padding_left = 10,
      padding_right = 10,
      color = colors.grey,
      highlight_color = space_colors[i],
    },
    label = {
      drawing = false,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.transparent,
      border_width = 0,
      height = 25,
    },
  })

  spaces[i] = space

  sbar.add("space", "space.padding." .. i, {
    space = i,
    script = "",
    width = 2,
  })

  space:subscribe("mouse.clicked", function(env)
    sbar.exec("aerospace workspace " .. i)
  end)

  space:subscribe("mouse.entered", function(env)
    sbar.animate("tanh", 20, function()
      space:set({
        icon = { color = space_colors[i] },
        background = { color = colors.with_alpha(space_colors[i], 0.15) },
      })
    end)
  end)

  space:subscribe("mouse.exited", function(env)
    local focused = space:query().icon.highlight == "on"
    sbar.animate("tanh", 20, function()
      space:set({
        icon = { color = focused and space_colors[i] or colors.grey },
        background = { color = colors.transparent },
      })
    end)
  end)
end

local workspace_logger = sbar.add("item", {
  drawing = false,
  updates = true,
})

workspace_logger:subscribe("aerospace_workspace_change", function(env)
  local focused_workspace = env.FOCUSED_WORKSPACE

  for _, i in ipairs(space_ids) do
    local space = spaces[i]
    local selected = (focused_workspace == i)
    space:set({
      icon = {
        highlight = selected,
        color = selected and space_colors[i] or colors.grey,
      },
      background = {
        color = selected and colors.with_alpha(space_colors[i], 0.15) or colors.transparent,
      },
    })
  end
end)
