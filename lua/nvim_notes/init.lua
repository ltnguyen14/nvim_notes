local M = {}
local core = require"nvim_notes.core"
local diag = require"nvim_notes.core.diag"
local util = require"nvim_notes.utils"
local notes = {}

M.setup = function ()
  require("nvim_notes.core.autocmd")
  notes = core.loadNotes()
end

M.printNotes = function ()
  print(vim.inspect(notes))
end

M.saveNotes = function ()
  core.saveNotes(notes)
end

M.addNote = function (filePath, line, note)
  if (notes[filePath]) then
    table.insert(notes[filePath], string.format("%s: %s", line, note))
  else
    notes[filePath] = {string.format("%s: %s", line, note)}
  end
end

M.addNoteToBuffer = function (line, note)
  local filePath = vim.api.nvim_buf_get_name(0)
  if (notes[filePath]) then
    table.insert(notes[filePath], string.format("%s: %s", line, note))
  else
    notes[filePath] = {string.format("%s: %s", line, note)}
  end
end

M.getNotesByFile = function (filePath)
  local lineMessages = notes[filePath]
  if lineMessages then
    local allNotes = {}
    for _, lineRaw in ipairs(lineMessages) do
      table.insert(allNotes, util.parseLineAndMsg(lineRaw))
    end
    return allNotes;
  end

  return nil
end

M.showNotesInBuffer = function ()
  local bufferPath = vim.api.nvim_buf_get_name(0)
  local bufferNotesRaw = M.getNotesByFile(bufferPath)

  if bufferNotesRaw then
    local bufferNotes = {}
    for _, note in ipairs(bufferNotesRaw) do
      table.insert(bufferNotes, {
        lnum = note["line"],
        end_lnum = note["line"],
        col = 0,
        end_col = 1000,
        message = note["msg"],
        severity = vim.diagnostic.severity.WARN
      })
    end
    diag.createDiag(bufferNotes)
  end
end

return M
