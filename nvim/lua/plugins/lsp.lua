-- LSP configuration to disable marksman diagnostics completely
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          -- Disable diagnostics handler
          handlers = {
            ["textDocument/publishDiagnostics"] = function() end,
          },
        },
        pyright = {
          capabilities = {
            textDocument = {
              signatureHelp = vim.NIL,
            },
          },
          on_attach = function(client, bufnr)
            -- Forcefully disable signature help provider
            if client.server_capabilities then
              client.server_capabilities.signatureHelpProvider = nil
            end
          end,
        },
      },
    },
  },
}
