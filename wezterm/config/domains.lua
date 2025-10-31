-- Unix domain configuration for persistent sessions
-- This allows tabs/workspaces to persist when closing wezterm

return {
   -- Unix domain for Mac/Linux
   unix_domains = {
      {
         name = 'unix',
         no_serve_automatically = false,
      },
   },

   -- Auto-connect to unix domain on startup for persistent sessions
   default_gui_startup_args = { 'connect', 'unix' },

   -- Default workspace name
   default_workspace = 'dev',

   -- SSH domains (can be extended later)
   ssh_domains = {},

   -- WSL domains (not needed on Mac)
   wsl_domains = {},
}
