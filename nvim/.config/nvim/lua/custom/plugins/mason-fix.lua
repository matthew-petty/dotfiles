-- Pin to stable v2.x versions that work with vim.lsp.config() API
-- These versions are compatible with Neovim 0.11+ and the new LSP config system
return {
  { "mason-org/mason.nvim", version = "v2.1.2" },
  { "mason-org/mason-lspconfig.nvim", version = "v1.33.0" },
}
-- Run :Lazy sync to update to these versions