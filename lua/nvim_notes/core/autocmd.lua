local nvim_notes = require"nvim_notes"

vim.api.nvim_create_augroup("nvim_notes", {})
vim.api.nvim_create_autocmd({"BufEnter"}, {
  callback = function()
    require("nvim_notes").showNotesInBuffer()
  end
})

vim.api.nvim_create_user_command("NvimNotesCreateNote",
  function (args)
    nvim_notes.addNoteToLine(args.args)
    nvim_notes.showNotesInBuffer()
    nvim_notes.saveNotes()
  end,
  {}
)

vim.api.nvim_create_user_command("NvimNotesOpenNote",
  function ()
    nvim_notes.openNote()
  end,
  {}
)
