local wezterm = require('wezterm')
local platform = require('utils.platform')
local backdrops = require('utils.backdrops')
local act = wezterm.action

local mod = {}

if platform.is_mac then
   mod.SUPER = 'SUPER'
   mod.SUPER_REV = 'SUPER|CTRL'
elseif platform.is_win or platform.is_linux then
   mod.SUPER = 'ALT' -- to not conflict with Windows key shortcuts
   mod.SUPER_REV = 'ALT|CTRL'
end

-- stylua: ignore
local keys = {
   -- misc/useful --
   { key = 'F1', mods = 'NONE', action = 'ActivateCopyMode' },
   { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
   { key = 'F3', mods = 'NONE', action = act.ShowLauncher },
   { key = 'F4', mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS' }) },
   {
      key = 'F5',
      mods = 'NONE',
      action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
   },
   { key = 'F11', mods = 'NONE',    action = act.ToggleFullScreen },
   { key = 'F12', mods = 'NONE',    action = act.ShowDebugOverlay },
   { key = 'f',   mods = mod.SUPER, action = act.Search({ CaseInSensitiveString = '' }) },
   { key = ',',   mods = mod.SUPER, action = act.ActivateCommandPalette }, -- Cmd+, for settings (opens command palette)
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
            wezterm.log_info('opening: ' .. url)
            wezterm.open_with(url)
         end),
      }),
   },

   -- copy/paste (Mac native: Cmd+C/V) --
   { key = 'c',          mods = mod.SUPER,     action = act.CopyTo('Clipboard') },
   { key = 'v',          mods = mod.SUPER,     action = act.PasteFrom('Clipboard') },

   -- cursor movement (Mac native: Cmd+Left/Right = Home/End) --
   { key = 'LeftArrow',  mods = mod.SUPER,     action = act.SendString '\u{1b}OH' },
   { key = 'RightArrow', mods = mod.SUPER,     action = act.SendString '\u{1b}OF' },
   { key = 'Backspace',  mods = mod.SUPER,     action = act.SendString '\u{15}' },

   -- tabs --
   -- tabs: spawn+close (Mac native: Cmd+T new, Cmd+W close)
   { key = 't',          mods = mod.SUPER,     action = act.SpawnTab('DefaultDomain') },
   { key = 'w',          mods = mod.SUPER,     action = act.CloseCurrentTab({ confirm = false }) },

   -- tabs: navigation (Mac native: Cmd+Shift+[ / ] for prev/next, Cmd+1-9 for specific tabs)
   { key = '[',          mods = mod.SUPER_REV, action = act.ActivateTabRelative(-1) },
   { key = ']',          mods = mod.SUPER_REV, action = act.ActivateTabRelative(1) },
   { key = '1',          mods = mod.SUPER,     action = act.ActivateTab(0) },
   { key = '2',          mods = mod.SUPER,     action = act.ActivateTab(1) },
   { key = '3',          mods = mod.SUPER,     action = act.ActivateTab(2) },
   { key = '4',          mods = mod.SUPER,     action = act.ActivateTab(3) },
   { key = '5',          mods = mod.SUPER,     action = act.ActivateTab(4) },
   { key = '6',          mods = mod.SUPER,     action = act.ActivateTab(5) },
   { key = '7',          mods = mod.SUPER,     action = act.ActivateTab(6) },
   { key = '8',          mods = mod.SUPER,     action = act.ActivateTab(7) },
   { key = '9',          mods = mod.SUPER,     action = act.ActivateTab(-1) }, -- last tab

   -- tabs: move tabs (Cmd+Alt+[ / ])
   { key = '[',          mods = 'SUPER|ALT',   action = act.MoveTabRelative(-1) },
   { key = ']',          mods = 'SUPER|ALT',   action = act.MoveTabRelative(1) },

   -- tab: title
   { key = 'e',          mods = mod.SUPER_REV, action = act.EmitEvent('tabs.manual-update-tab-title') },
   { key = 'r',          mods = mod.SUPER_REV, action = act.EmitEvent('tabs.reset-tab-title') },

   -- tab: hide tab-bar (Cmd+Shift+B, similar to bookmark bar in browsers)
   { key = 'b',          mods = mod.SUPER_REV, action = act.EmitEvent('tabs.toggle-tab-bar') },

   -- window --
   -- window: spawn windows (Mac native: Cmd+N)
   { key = 'n',          mods = mod.SUPER,     action = act.SpawnWindow },

   -- font size (Mac native: Cmd+=/- for zoom, Cmd+0 for reset)
   { key = '=',          mods = mod.SUPER,     action = act.IncreaseFontSize },
   { key = '-',          mods = mod.SUPER,     action = act.DecreaseFontSize },
   { key = '0',          mods = mod.SUPER,     action = act.ResetFontSize },

   -- window: fullscreen (Mac native: Cmd+Ctrl+F)
   { key = 'f',          mods = 'SUPER|CTRL',  action = act.ToggleFullScreen },

   -- background controls --
   {
      key = '/',
      mods = 'SUPER|ALT',
      action = wezterm.action_callback(function(window, _pane)
         backdrops:random(window)
      end),
   },
   {
      key = ',',
      mods = 'SUPER|ALT',
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_back(window)
      end),
   },
   {
      key = '.',
      mods = 'SUPER|ALT',
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_forward(window)
      end),
   },
   {
      key = '/',
      mods = mod.SUPER_REV,
      action = act.InputSelector({
         title = 'InputSelector: Select Background',
         choices = backdrops:choices(),
         fuzzy = true,
         fuzzy_description = 'Select Background: ',
         action = wezterm.action_callback(function(window, _pane, idx)
            if not idx then
               return
            end
            ---@diagnostic disable-next-line: param-type-mismatch
            backdrops:set_img(window, tonumber(idx))
         end),
      }),
   },

   -- panes --
   -- panes: split panes (Cmd+D for horizontal like iTerm2, Cmd+Shift+D for vertical)
   { key = 'd',          mods = mod.SUPER,     action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
   { key = 'd',          mods = mod.SUPER_REV, action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },

   -- panes: close pane (Cmd+Shift+W)
   { key = 'w',          mods = mod.SUPER_REV, action = act.CloseCurrentPane({ confirm = false }) },

   -- panes: zoom pane (Cmd+Shift+Enter)
   { key = 'Enter',      mods = mod.SUPER_REV, action = act.TogglePaneZoomState },

   -- panes: navigation (Cmd+Alt+Arrow keys, more Mac-like)
   { key = 'UpArrow',    mods = 'SUPER|ALT',   action = act.ActivatePaneDirection('Up') },
   { key = 'DownArrow',  mods = 'SUPER|ALT',   action = act.ActivatePaneDirection('Down') },
   { key = 'LeftArrow',  mods = 'SUPER|ALT',   action = act.ActivatePaneDirection('Left') },
   { key = 'RightArrow', mods = 'SUPER|ALT',   action = act.ActivatePaneDirection('Right') },

   -- panes: navigation (vim-style alternative with Cmd+Ctrl)
   { key = 'k',          mods = 'SUPER|CTRL',  action = act.ActivatePaneDirection('Up') },
   { key = 'j',          mods = 'SUPER|CTRL',  action = act.ActivatePaneDirection('Down') },
   { key = 'h',          mods = 'SUPER|CTRL',  action = act.ActivatePaneDirection('Left') },
   { key = 'l',          mods = 'SUPER|CTRL',  action = act.ActivatePaneDirection('Right') },

   -- panes: select pane
   {
      key = 'p',
      mods = mod.SUPER_REV,
      action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }),
   },

   -- panes: resize (Cmd+Ctrl+Shift+Arrow keys)
   { key = 'LeftArrow',  mods = 'SUPER|CTRL|SHIFT', action = act.AdjustPaneSize({ 'Left', 5 }) },
   { key = 'RightArrow', mods = 'SUPER|CTRL|SHIFT', action = act.AdjustPaneSize({ 'Right', 5 }) },
   { key = 'UpArrow',    mods = 'SUPER|CTRL|SHIFT', action = act.AdjustPaneSize({ 'Up', 5 }) },
   { key = 'DownArrow',  mods = 'SUPER|CTRL|SHIFT', action = act.AdjustPaneSize({ 'Down', 5 }) },

   -- scrolling (Shift+Arrow for line-by-line, PageUp/Down for pages)
   { key = 'PageUp',     mods = 'NONE',        action = act.ScrollByPage(-0.75) },
   { key = 'PageDown',   mods = 'NONE',        action = act.ScrollByPage(0.75) },
   { key = 'UpArrow',    mods = 'SHIFT',       action = act.ScrollByLine(-1) },
   { key = 'DownArrow',  mods = 'SHIFT',       action = act.ScrollByLine(1) },
}

-- stylua: ignore
local key_tables = {
   resize_font = {
      { key = 'k',      action = act.IncreaseFontSize },
      { key = 'j',      action = act.DecreaseFontSize },
      { key = 'r',      action = act.ResetFontSize },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
   resize_pane = {
      { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
      { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
}

local mouse_bindings = {
   -- Ctrl-click will open the link under the mouse cursor
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
   },
}

return {
   disable_default_key_bindings = true,
   -- disable_default_mouse_bindings = true,
   leader = { key = 'Space', mods = mod.SUPER_REV },
   keys = keys,
   key_tables = key_tables,
   mouse_bindings = mouse_bindings,
}
