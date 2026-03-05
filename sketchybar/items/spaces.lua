local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}
local space_ids = { "1", "2", "3", "4", "C", "S" }

-- Catppuccin colors matched to workspace identity
local space_colors = {
  ["1"] = colors.blue,      -- terminal (Ghostty)
  ["2"] = colors.green,     -- browsers
  ["3"] = colors.magenta,   -- notes (Obsidian)
  ["4"] = colors.yellow,    -- messaging
  ["C"] = colors.blue,      -- code (VS Code blue)
  ["S"] = colors.green,     -- spotify green
}

-- Build icon strip from app names in a workspace
local function get_icon_strip(app_list)
  local icons = {}
  for app in app_list:gmatch("[^\r\n]+") do
    app = app:match("^%s*(.-)%s*$") -- trim whitespace
    if app ~= "" then
      local icon = app_icons[app] or app_icons["Default"] or ":default:"
      table.insert(icons, icon)
    end
  end
  if #icons == 0 then
    return ""
  end
  return table.concat(icons, " ")
end

-- Create space items
for _, i in ipairs(space_ids) do
  local space = sbar.add("item", "space." .. i, {
    icon = {
      font = { family = settings.font.text, size = 13.0 },
      string = i,
      padding_left = 8,
      padding_right = 2,
      color = colors.grey,
      highlight_color = space_colors[i],
    },
    label = {
      font = "sketchybar-app-font:Regular:16.0",
      string = "",
      padding_left = 6,
      padding_right = 8,
      color = colors.grey,
      highlight_color = space_colors[i],
      y_offset = -1,
    },
    padding_right = 2,
    padding_left = 2,
    background = {
      color = colors.transparent,
      border_width = 0,
      height = 26,
      corner_radius = 8,
    },
    drawing = false,
  })

  spaces[i] = space

  space:subscribe("mouse.clicked", function(env)
    sbar.exec("aerospace workspace " .. i)
  end)

  space:subscribe("mouse.entered", function(env)
    sbar.animate("tanh", 20, function()
      space:set({
        icon = { color = space_colors[i] },
        label = { color = space_colors[i] },
        background = { color = colors.bg1 },
      })
    end)
  end)

  space:subscribe("mouse.exited", function(env)
    local focused = space:query().label.highlight == "on"
    sbar.animate("tanh", 20, function()
      space:set({
        icon = { color = focused and space_colors[i] or colors.grey },
        label = { color = focused and space_colors[i] or colors.grey },
        background = {
          color = focused and colors.bg1 or colors.transparent,
        },
      })
    end)
  end)
end

-- Update a single workspace's icon strip
local function update_space(workspace_id, focused_workspace)
  local space = spaces[workspace_id]
  if not space then return end

  sbar.exec(
    "aerospace list-windows --workspace " .. workspace_id .. " --format '%{app-name}'",
    function(app_list)
      local icon_strip = get_icon_strip(app_list)
      local is_focused = (workspace_id == focused_workspace)
      local has_windows = (icon_strip ~= "")

      local should_draw = has_windows or is_focused
      local display_label = has_windows and icon_strip or "—"

      space:set({
        drawing = should_draw,
        icon = {
          highlight = is_focused,
          color = is_focused and space_colors[workspace_id] or colors.grey,
        },
        label = {
          string = display_label,
          highlight = is_focused,
          color = is_focused and space_colors[workspace_id] or colors.grey,
        },
        background = {
          color = is_focused and colors.bg1 or colors.transparent,
        },
      })
    end
  )
end

-- Update all workspaces
local function update_all_spaces()
  sbar.exec("aerospace list-workspaces --focused", function(focused)
    focused = focused:match("^%s*(.-)%s*$")
    for _, id in ipairs(space_ids) do
      update_space(id, focused)
    end
  end)
end

-- Hidden item to receive events
local space_observer = sbar.add("item", "space_observer", {
  drawing = false,
  updates = true,
})

space_observer:subscribe("aerospace_workspace_change", function(env)
  local focused = env.FOCUSED_WORKSPACE
  for _, id in ipairs(space_ids) do
    update_space(id, focused)
  end
end)

space_observer:subscribe("front_app_switched", function(env)
  update_all_spaces()
end)

-- Initial load
update_all_spaces()
