-- Neo-tree configuration to completely hide diagnostic indicators
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    -- Hide all diagnostic symbols
    default_component_configs = {
      diagnostics = {
        symbols = {
          hint = "",
          info = "",
          warn = "",
          error = "",
        },
        highlights = {
          hint = "",
          info = "",
          warn = "",
          error = "",
        },
      },
    },
    -- Remove diagnostics from file renderers
    renderers = {
      file = {
        { "icon" },
        { "name", use_git_status_colors = true },
        { "git_status", highlight = "NeoTreeDimText" },
        -- "diagnostics" component removed
      },
      directory = {
        { "icon" },
        { "current_filter" },
        { "name" },
        { "git_status", highlight = "NeoTreeDimText" },
      },
    },
  },
}
