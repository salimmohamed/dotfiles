return {
  "saghen/blink.cmp",
  opts = {
    enabled = function()
      return vim.bo.filetype ~= "markdown"
    end,
    completion = {
      documentation = {
        auto_show = false,
        auto_show_delay_ms = 999999,
      },
    },
    signature = {
      enabled = false,
      trigger = {
        enabled = false,
        show_on_trigger_character = false,
        show_on_insert_on_trigger_character = false,
        show_on_accept_on_trigger_character = false,
      },
    },
  },
}
