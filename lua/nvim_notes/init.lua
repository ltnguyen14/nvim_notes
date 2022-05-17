local M = {}
local core = require"nvim_notes.core"
local diag = require"nvim_notes.core.diag"
local util = require"nvim_notes.utils"
local notes = {}
local current_file
local current_line

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

M.addNoteToLine = function (note)
  local filePath = vim.api.nvim_buf_get_name(0)
  local cursorLine, cursorColumn = unpack(vim.api.nvim_win_get_cursor(0))
  cursorLine = cursorLine - 1;
  if (notes[filePath]) then
    table.insert(notes[filePath], string.format("%s: %s", cursorLine, note))
  else
    notes[filePath] = {string.format("%s: %s", cursorLine, note)}
  end
end

M.getNoteForLine = function ()
  local filePath = vim.api.nvim_buf_get_name(0)
  local cursorLine, cursorColumn = unpack(vim.api.nvim_win_get_cursor(0))
  cursorLine = cursorLine - 1;
  current_line = cursorLine
  current_file = filePath

  if notes[filePath] then
    local allNotes = {}
    for _, lineRaw in ipairs(notes[filePath]) do
      local lineData = util.parseLineAndMsg(lineRaw)
      if lineData and lineData.line == cursorLine then
        table.insert(allNotes, lineData.msg)
      end
    end
    return allNotes
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

M.openNote = function ()
  local windowOptions = vim.lsp.util.make_floating_popup_options(40, 20)
  windowOptions.border = "rounded"
  local buf = vim.api.nvim_create_buf(false, true)
  local notesForLine = M.getNoteForLine()
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, notesForLine)

  vim.api.nvim_open_win(buf, true, windowOptions)
end

M.updateNoteBuffer = function ()
  local newNotes = vim.api.nvim_buf_get_lines(0, 0, -1, true)

  if notes[current_file] then
    for _, msg in ipairs(newNotes) do
      table.insert(notes[current_file], string.format('%s: %s', current_line, msg))
    end
  end

  M.saveNotes()
end

return M
