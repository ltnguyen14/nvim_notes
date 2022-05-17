local M = {}

M.parseLineAndMsg = function (rawLine)
  if rawLine then
    local lineMsg = {}
    for line, msg in string.gmatch(rawLine, "(.*): (.*)") do
      lineMsg["line"] = tonumber(line, 10)
      lineMsg["msg"] = msg
    end

    return lineMsg
  end

  return nil
end

return M
