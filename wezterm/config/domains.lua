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

   -- Default workspace name
   default_workspace = 'default',

   -- SSH domains (can be extended later)
   ssh_domains = {},

   -- WSL domains (not needed on Mac)
   wsl_domains = {},
}
