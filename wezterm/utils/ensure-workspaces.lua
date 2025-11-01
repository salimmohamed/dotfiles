local wezterm = require("wezterm")

local M = {}

-- Get workspace home directories
local workspace_homes = require("config.workspace-homes")

-- Helper function to check if a workspace exists
local function workspace_exists(workspace_name)
	local mux = wezterm.mux
	local workspaces = mux.get_workspace_names()
	for _, name in ipairs(workspaces) do
		if name == workspace_name then
			return true
		end
	end
	return false
end

-- Ensure all defined workspaces exist
M.ensure_all_workspaces = wezterm.action_callback(function(win, pane)
	local mux = wezterm.mux

	-- Create workspaces for each defined home directory
	for workspace_name, cwd in pairs(workspace_homes) do
		if not workspace_exists(workspace_name) then
			wezterm.log_info("Creating missing workspace: " .. workspace_name)
			mux.spawn_window({
				workspace = workspace_name,
				cwd = cwd,
			})
		end
	end
end)

return M
