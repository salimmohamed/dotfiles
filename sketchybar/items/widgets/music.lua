local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local music_icon = sbar.add("item", "widgets.music.icon", {
  position = "right",
  icon = {
    string = icons.media.play_pause,
    font = { size = 12.0 },
    color = colors.magenta,
    padding_left = 4,
    padding_right = 4,
  },
  label = { drawing = false },
  drawing = false,
})

local music_title = sbar.add("item", "widgets.music.title", {
  position = "right",
  icon = { drawing = false },
  label = {
    max_chars = 30,
    font = {
      style = settings.font.style_map["Semibold"],
      size = 11.0,
    },
    color = colors.white,
  },
  drawing = false,
  scroll_texts = true,
})

local music_controls = sbar.add("item", "widgets.music.controls", {
  position = "right",
  icon = { drawing = false },
  label = {
    string = icons.media.back .. "  " .. icons.media.play_pause .. "  " .. icons.media.forward,
    font = { size = 12.0 },
    color = colors.magenta,
    padding_left = 4,
    padding_right = 4,
  },
  drawing = false,
})

sbar.add("bracket", "widgets.music.bracket", {
  music_controls.name,
  music_title.name,
  music_icon.name,
}, {
  background = { color = colors.bg1 },
})

-- Padding starts hidden (no music playing by default)
local music_padding = sbar.add("item", "widgets.music.padding", {
  position = "right",
  width = 0,
})

-- Hidden listener that always receives media_change events
local music_listener = sbar.add("item", {
  drawing = false,
  updates = true,
})

music_listener:subscribe("media_change", function(env)
  local app = env.INFO and env.INFO.app
  if not app then return end

  local state = env.INFO.state
  if state == "playing" then
    local artist = env.INFO.artist or ""
    local title = env.INFO.title or ""
    local display = title
    if artist ~= "" then
      display = artist .. " — " .. title
    end

    music_icon:set({ drawing = true })
    music_title:set({
      drawing = true,
      label = { string = display },
    })
    music_controls:set({ drawing = true })
    music_padding:set({ width = settings.group_paddings })
  else
    music_icon:set({ drawing = false })
    music_title:set({ drawing = false })
    music_controls:set({ drawing = false })
    music_padding:set({ width = 0 })
  end
end)

music_controls:subscribe("mouse.clicked", function(env)
  sbar.exec([[osascript -e 'tell application "Spotify"
    if player state is playing then
      pause
    else
      play
    end if
  end tell' 2>/dev/null || osascript -e 'tell application "Music"
    if player state is playing then
      pause
    else
      play
    end if
  end tell' 2>/dev/null]])
end)
