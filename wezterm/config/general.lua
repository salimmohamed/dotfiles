return {
   -- Behaviors
   automatically_reload_config = true,
   exit_behavior = 'CloseOnCleanExit',
   exit_behavior_messaging = 'Verbose',
   status_update_interval = 1000,
   audible_bell = 'Disabled',

   -- Scrollback
   scrollback_lines = 10000,

   -- Pane settings
   pane_focus_follows_mouse = true,
   inactive_pane_hsb = {
      saturation = 0.8,
      brightness = 0.7,
   },

   -- Window settings
   window_decorations = 'RESIZE',
   window_padding = {
      left = 0,
      right = 0,
      top = 0,
      bottom = 0,
   },

   -- Misc
   use_dead_keys = false,

   -- Mac Option/Alt key handling
   -- Prevents Option from sending special characters, allows it to work as modifier
   send_composed_key_when_left_alt_is_pressed = false,
   send_composed_key_when_right_alt_is_pressed = false,

   -- Background rotation settings
   -- Automatic rotation every 30 minutes (configured in events/right-status.lua)
   -- To adjust interval, edit ROTATION_INTERVAL in events/right-status.lua:
   --   900 = 15 minutes | 1800 = 30 minutes | 3600 = 1 hour
   -- Rotation pauses during focus mode automatically

   -- Hyperlink rules
   hyperlink_rules = {
      -- Matches: a URL in parens: (URL)
      {
         regex = '\\((\\w+://\\S+)\\)',
         format = '$1',
         highlight = 1,
      },
      -- Matches: a URL in brackets: [URL]
      {
         regex = '\\[(\\w+://\\S+)\\]',
         format = '$1',
         highlight = 1,
      },
      -- Matches: a URL in curly braces: {URL}
      {
         regex = '\\{(\\w+://\\S+)\\}',
         format = '$1',
         highlight = 1,
      },
      -- Matches: a URL in angle brackets: <URL>
      {
         regex = '<(\\w+://\\S+)>',
         format = '$1',
         highlight = 1,
      },
      -- Then handle URLs not wrapped in brackets
      {
         regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
         format = '$0',
      },
      -- implicit mailto link
      {
         regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',
         format = 'mailto:$0',
      },
   },
}
