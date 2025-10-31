local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- Get workspace home directories
local workspace_homes = require("config.workspace-homes")

-- Smart close tab action that prevents workspace deletion
-- If closing the last tab in a workspace, spawns a new tab first
M.smart_close_tab = wezterm.action_callback(function(win, pane)
	local mux_window = win:mux_window()
	local workspace = mux_window:get_workspace()
	local tab_count = #mux_window:tabs()

	-- If this is the last tab in the workspace, spawn a new one first
	if tab_count == 1 then
		-- Get the home directory for this workspace, if defined
		local cwd = workspace_homes[workspace]

		-- Spawn a new tab in the workspace's home directory
		if cwd then
			mux_window:spawn_tab({ cwd = cwd })
		else
			-- If workspace doesn't have a defined home, use current directory
			mux_window:spawn_tab({})
		end
	end

	-- Now close the current tab
	win:perform_action(act.CloseCurrentTab({ confirm = false }), pane)
end)

-- Smart close pane action that prevents workspace deletion
-- If closing the last pane in the last tab, spawns a new tab first
M.smart_close_pane = wezterm.action_callback(function(win, pane)
	local mux_window = win:mux_window()
	local workspace = mux_window:get_workspace()
	local tab = win:active_tab()
	local pane_count = #tab:panes()
	local tab_count = #mux_window:tabs()

	-- If this is the last pane in the last tab, spawn a new tab first
	if tab_count == 1 and pane_count == 1 then
		-- Get the home directory for this workspace, if defined
		local cwd = workspace_homes[workspace]

		-- Spawn a new tab in the workspace's home directory
		if cwd then
			mux_window:spawn_tab({ cwd = cwd })
		else
			-- If workspace doesn't have a defined home, use current directory
			mux_window:spawn_tab({})
		end
	end

	-- Now close the current pane
	win:perform_action(act.CloseCurrentPane({ confirm = false }), pane)
end)

return M
