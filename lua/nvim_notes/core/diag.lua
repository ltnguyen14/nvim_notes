local M = {}

M.createDiag = function (msg)
  local namespace = vim.api.nvim_create_namespace("nvim_notes")
  vim.diagnostic.set(namespace, 0, msg)
end

return M
