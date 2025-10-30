local wezterm = require('wezterm')
local platform = require('utils.platform')
local backdrops = require('utils.backdrops')
local is_vim = require('utils.is-vim')
local act = wezterm.action

local mod = {}

if platform.is_mac then
   mod.SUPER = 'SUPER'
   mod.SUPER_REV = 'SUPER|CTRL'
elseif platform.is_win or platform.is_linux then
   mod.SUPER = 'ALT'
   mod.SUPER_REV = 'ALT|CTRL'
end

-- Smart navigation: pass keys to vim if it's running, otherwise navigate wezterm panes
local function split_nav(direction_wez, direction_nvim)
   return {
      key = direction_nvim,
      mods = 'CTRL',
      action = wezterm.action_callback(function(win, pane)
         if is_vim(pane) then
            -- Pass through to nvim
            win:perform_action(act.SendKey({ key = direction_nvim, mods = 'CTRL' }), pane)
         else
            -- Navigate wezterm panes
            win:perform_action(act.ActivatePaneDirection(direction_wez), pane)
         end
      end),
   }
end

-- Smart resize: pass keys to vim if it's running, otherwise resize wezterm panes
local function resize_nav(direction_wez, direction_nvim)
   return {
      key = direction_nvim,
      mods = 'META',
      action = wezterm.action_callback(function(win, pane)
         if is_vim(pane) then
            -- Pass through to nvim
            win:perform_action(act.SendKey({ key = direction_nvim, mods = 'META' }), pane)
         else
            -- Resize wezterm panes
            win:perform_action(act.AdjustPaneSize({ direction_wez, 3 }), pane)
         end
      end),
   }
end

local keys = {
   -- Misc/Useful
   { key = 'F1', mods = 'NONE', action = act.ActivateCopyMode },
   { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
   { key = 'F3', mods = 'NONE', action = act.ShowLauncher },
   { key = 'F4', mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS' }) },
   { key = 'F5', mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }) },
   { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },
   { key = 'F12', mods = 'NONE', action = act.ShowDebugOverlay },
   { key = 'f', mods = mod.SUPER, action = act.Search({ CaseInSensitiveString = '' }) },
   { key = ',', mods = mod.SUPER, action = act.ActivateCommandPalette },
   {
      key = 'u',
      mods = mod.SUPER_REV,
      action = wezterm.action.QuickSelectArgs({
         label = 'open url',
         patterns = {
            '\\((https?://\\S+)\\)',
            '\\[(https?://\\S+)\\]',
            '\\{(https?://\\S+)\\}',
            '<(https?://\\S+)>',
            '\\bhttps?://\\S+[)/a-zA-Z0-9-]+',
         },
         action = wezterm.action_callback(function(window, pane)
            local url = window:get_selection_text_for_pane(pane)
            wezterm.open_with(url)
         end),
      }),
   },

   -- Copy/Paste
   { key = 'c', mods = mod.SUPER, action = act.CopyTo('Clipboard') },
   { key = 'v', mods = mod.SUPER, action = act.PasteFrom('Clipboard') },

   -- Cursor movement (Mac native)
   { key = 'LeftArrow', mods = mod.SUPER, action = act.SendString('\x1bOH') },
   { key = 'RightArrow', mods = mod.SUPER, action = act.SendString('\x1bOF') },
   { key = 'Backspace', mods = mod.SUPER, action = act.SendString('\x15') },

   -- Tabs
   { key = 't', mods = mod.SUPER, action = act.SpawnTab('CurrentPaneDomain') },
   { key = 'w', mods = mod.SUPER, action = act.CloseCurrentTab({ confirm = false }) },

   -- Tab navigation
   { key = '[', mods = mod.SUPER_REV, action = act.ActivateTabRelative(-1) },
   { key = ']', mods = mod.SUPER_REV, action = act.ActivateTabRelative(1) },
   { key = '1', mods = mod.SUPER, action = act.ActivateTab(0) },
   { key = '2', mods = mod.SUPER, action = act.ActivateTab(1) },
   { key = '3', mods = mod.SUPER, action = act.ActivateTab(2) },
   { key = '4', mods = mod.SUPER, action = act.ActivateTab(3) },
   { key = '5', mods = mod.SUPER, action = act.ActivateTab(4) },
   { key = '6', mods = mod.SUPER, action = act.ActivateTab(5) },
   { key = '7', mods = mod.SUPER, action = act.ActivateTab(6) },
   { key = '8', mods = mod.SUPER, action = act.ActivateTab(7) },
   { key = '9', mods = mod.SUPER, action = act.ActivateTab(-1) },

   -- Move tabs
   { key = '[', mods = 'SUPER|ALT', action = act.MoveTabRelative(-1) },
   { key = ']', mods = 'SUPER|ALT', action = act.MoveTabRelative(1) },

   -- Tab title
   { key = 'e', mods = mod.SUPER_REV, action = act.EmitEvent('tabs.manual-update-tab-title') },
   { key = 'r', mods = mod.SUPER_REV, action = act.EmitEvent('tabs.reset-tab-title') },

   -- Hide tab bar
   { key = 'b', mods = mod.SUPER_REV, action = act.EmitEvent('tabs.toggle-tab-bar') },

   -- Windows
   { key = 'n', mods = mod.SUPER, action = act.SpawnWindow },

   -- Font size
   { key = '=', mods = mod.SUPER, action = act.IncreaseFontSize },
   { key = '-', mods = mod.SUPER, action = act.DecreaseFontSize },
   { key = '0', mods = mod.SUPER, action = act.ResetFontSize },

   -- Fullscreen
   { key = 'f', mods = 'SUPER|CTRL', action = act.ToggleFullScreen },

   -- Background controls
   {
      key = '/',
      mods = 'SUPER|ALT',
      action = wezterm.action_callback(function(window, _)
         backdrops:random(window)
      end),
   },
   {
      key = ',',
      mods = 'SUPER|ALT',
      action = wezterm.action_callback(function(window, _)
         backdrops:cycle_back(window)
      end),
   },
   {
      key = '.',
      mods = 'SUPER|ALT',
      action = wezterm.action_callback(function(window, _)
         backdrops:cycle_forward(window)
      end),
   },
   {
      key = '/',
      mods = mod.SUPER_REV,
      action = act.InputSelector({
         title = 'Select Background',
         choices = backdrops:choices(),
         fuzzy = true,
         action = wezterm.action_callback(function(window, _, idx)
            if idx then
               backdrops:set_img(window, tonumber(idx))
            end
         end),
      }),
   },

   -- Focus mode toggle
   {
      key = 'f',
      mods = 'SUPER|ALT',
      action = wezterm.action_callback(function(window, _)
         backdrops:toggle_focus(window)
      end),
   },

   -- Panes
   { key = 'd', mods = mod.SUPER, action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
   { key = 'd', mods = mod.SUPER_REV, action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
   { key = 'w', mods = mod.SUPER_REV, action = act.CloseCurrentPane({ confirm = false }) },
   { key = 'Enter', mods = mod.SUPER_REV, action = act.TogglePaneZoomState },

   -- Pane selection
   {
      key = 'p',
      mods = mod.SUPER_REV,
      action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }),
   },

   -- Smart navigation (Ctrl+hjkl) - works with both nvim and wezterm
   split_nav('Left', 'h'),
   split_nav('Down', 'j'),
   split_nav('Up', 'k'),
   split_nav('Right', 'l'),

   -- Smart resize (Alt+hjkl) - works with both nvim and wezterm
   resize_nav('Left', 'h'),
   resize_nav('Down', 'j'),
   resize_nav('Up', 'k'),
   resize_nav('Right', 'l'),

   -- Workspace management
   {
      key = 'k',
      mods = mod.SUPER,
      action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
   },
   {
      key = 'n',
      mods = mod.SUPER_REV,
      action = act.PromptInputLine({
         description = 'Enter workspace name:',
         action = wezterm.action_callback(function(window, pane, line)
            if line then
               window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
            end
         end),
      }),
   },

   -- Scrolling
   { key = 'PageUp', mods = 'NONE', action = act.ScrollByPage(-0.75) },
   { key = 'PageDown', mods = 'NONE', action = act.ScrollByPage(0.75) },
   { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollByLine(-1) },
   { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollByLine(1) },
}

local key_tables = {
   copy_mode = {
      -- Vim-like navigation
      { key = 'h', mods = 'NONE', action = act.CopyMode('MoveLeft') },
      { key = 'j', mods = 'NONE', action = act.CopyMode('MoveDown') },
      { key = 'k', mods = 'NONE', action = act.CopyMode('MoveUp') },
      { key = 'l', mods = 'NONE', action = act.CopyMode('MoveRight') },

      -- Word movement
      { key = 'w', mods = 'NONE', action = act.CopyMode('MoveForwardWord') },
      { key = 'b', mods = 'NONE', action = act.CopyMode('MoveBackwardWord') },
      { key = 'e', mods = 'NONE', action = act.CopyMode('MoveForwardWordEnd') },

      -- Line movement
      { key = '0', mods = 'NONE', action = act.CopyMode('MoveToStartOfLine') },
      { key = '$', mods = 'SHIFT', action = act.CopyMode('MoveToEndOfLineContent') },
      { key = '^', mods = 'SHIFT', action = act.CopyMode('MoveToStartOfLineContent') },

      -- Page movement
      { key = 'f', mods = 'CTRL', action = act.CopyMode('PageDown') },
      { key = 'b', mods = 'CTRL', action = act.CopyMode('PageUp') },
      { key = 'd', mods = 'CTRL', action = act.CopyMode('PageDown') },
      { key = 'u', mods = 'CTRL', action = act.CopyMode('PageUp') },

      -- Buffer navigation
      { key = 'g', mods = 'NONE', action = act.CopyMode('MoveToScrollbackTop') },
      { key = 'G', mods = 'SHIFT', action = act.CopyMode('MoveToScrollbackBottom') },

      -- Search
      { key = 'n', mods = 'NONE', action = act.CopyMode('NextMatch') },
      { key = 'N', mods = 'SHIFT', action = act.CopyMode('PriorMatch') },

      -- Selection
      { key = 'v', mods = 'NONE', action = act.CopyMode({ SetSelectionMode = 'Cell' }) },
      { key = 'V', mods = 'SHIFT', action = act.CopyMode({ SetSelectionMode = 'Line' }) },

      -- Copy
      {
         key = 'y',
         mods = 'NONE',
         action = act.Multiple({
            act.CopyTo('ClipboardAndPrimarySelection'),
            act.CopyMode('Close'),
         }),
      },

      -- Exit
      { key = 'Escape', mods = 'NONE', action = act.CopyMode('Close') },
      { key = 'q', mods = 'NONE', action = act.CopyMode('Close') },
   },
   search_mode = {
      { key = 'Escape', mods = 'NONE', action = act.CopyMode('Close') },
      { key = 'Enter', mods = 'NONE', action = act.ActivateCopyMode },
      { key = 'n', mods = 'CTRL', action = act.CopyMode('NextMatch') },
      { key = 'p', mods = 'CTRL', action = act.CopyMode('PriorMatch') },
      { key = 'r', mods = 'CTRL', action = act.CopyMode('CycleMatchType') },
      { key = 'u', mods = 'CTRL', action = act.CopyMode('ClearPattern') },
   },
}

local mouse_bindings = {
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
   },
}

return {
   disable_default_key_bindings = true,
   leader = { key = 'Space', mods = mod.SUPER_REV },
   keys = keys,
   key_tables = key_tables,
   mouse_bindings = mouse_bindings,
}
