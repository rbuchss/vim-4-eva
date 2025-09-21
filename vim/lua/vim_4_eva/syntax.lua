local M = {}

-- Cache to track which languages have already shown errors
local error_cache = {}

function M.is_commented(bufnr, lang, predicate)
  local ok, result = pcall(function()
    local parsers = require('nvim-treesitter.parsers')
    local ts = require('vim.treesitter')

    if not parsers.has_parser(lang) then
      error('No parser available for language: ' .. lang)
    end

    local parser = parsers.get_parser(bufnr)
    local tree = parser:parse()[1]
    local root = tree:root()

    local query = ts.query.parse(lang, '(comment) @comment')

    if not query then
      error('Failed to parse query for language: ' .. lang)
    end

    for _, node in query:iter_captures(root, bufnr) do
      local start_row, start_col, end_row, end_col = node:range()
      local predicate_result = predicate(start_row, start_col, end_row, end_col)

      if predicate_result ~= nil then
        return predicate_result
      end
    end

    return false
  end)

  if not ok then
    -- Only show error once per language
    local error_key = lang .. ":" .. tostring(result)

    if not error_cache[error_key] then
      vim.notify("Tree-sitter error in is_commented: " .. tostring(result), vim.log.levels.DEBUG)
      error_cache[error_key] = true
    end

    return false
  end

  return result
end

function M.is_line_commented(bufnr, lang, line)
  return M.is_commented(bufnr, lang, function(start_row, start_col, end_row, end_col)
    if line >= start_row and line <= end_row then
      return true
    end
  end)
end

function M.is_position_commented(bufnr, lang, line, col)
  return M.is_commented(bufnr, lang, function(start_row, start_col, end_row, end_col)
    -- Check if position is within the comment range
    if line > start_row and line < end_row then
      -- Line is completely within the comment
      return true
    elseif line == start_row and line == end_row then
      -- Single-line comment: check if column is within range
      return col >= start_col and col < end_col
    elseif line == start_row then
      -- First line of multi-line comment: check if column is after start
      return col >= start_col
    elseif line == end_row then
      -- Last line of multi-line comment: check if column is before end
      return col < end_col
    end
  end)
end

return M
