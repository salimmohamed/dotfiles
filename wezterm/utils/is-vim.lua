-- Utility to detect if the current pane is running neovim/vim
-- Used for smart navigation between wezterm panes and neovim splits

local function is_vim(pane)
   local process_info = pane:get_foreground_process_info()
   if not process_info then
      return false
   end

   local process_name = process_info.name
   if not process_name then
      return false
   end

   -- Check for vim, nvim, or their variants
   return process_name:find('n?vim') ~= nil
      or process_name:find('vim') ~= nil
end

return is_vim
