local diag = require"nvim_notes.core.diag"

vim.api.nvim_create_augroup("nvim_notes", {})
vim.api.nvim_create_autocmd({"BufEnter"}, {
  callback = function()
  end
})
