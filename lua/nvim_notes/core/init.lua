local M = {}

local jsonPath = "~/nvim_notes.json"

M.loadNotes = function ()
  local notes_raw = vim.fn.readfile(vim.fn.expand(jsonPath))
  return vim.json.decode(notes_raw[1]) -- assuming that it's all on one line
end

M.saveNotes = function (notes)
  vim.api.nvim_call_function("writefile", {{vim.json.encode(notes)}, vim.api.nvim_eval(string.format("expand(\"%s\")", jsonPath))})
  vim.fn.writefile({vim.json.encode(notes)}, vim.fn.expand(jsonPath))
end

return M
