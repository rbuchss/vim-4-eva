local M = {}

function M.is_line_commented(bufnr, lang, line)
  local ok, result = pcall(function()
    local parsers = require('nvim-treesitter.parsers')
    local ts = require('vim.treesitter')

    if not parsers.has_parser(lang) then
      return false
    end

    local parser = parsers.get_parser(bufnr)
    local tree = parser:parse()[1]
    local root = tree:root()

    local query = ts.query.parse(lang, '(comment) @comment')

    if not query then return false end

    for _, node in query:iter_captures(root, bufnr) do
      local start_row, _, end_row, _ = node:range()

      if line >= start_row and line <= end_row then
        return true
      end
    end

    return false
  end)

  if not ok then
    vim.notify("Tree-sitter error in is_line_commented: " .. tostring(result), vim.log.levels.DEBUG)
    return false
  end

  return result
end

function M.is_position_commented(bufnr, lang, line, col)
  local ok, result = pcall(function()
    local parsers = require('nvim-treesitter.parsers')
    local ts = require('vim.treesitter')

    if not parsers.has_parser(lang) then
      return false
    end

    local parser = parsers.get_parser(bufnr)
    local tree = parser:parse()[1]
    local root = tree:root()

    local query = ts.query.parse(lang, '(comment) @comment')

    if not query then return false end

    for _, node in query:iter_captures(root, bufnr) do
      local start_row, start_col, end_row, end_col = node:range()

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
    end

    return false
  end)

  if not ok then
    vim.notify("Tree-sitter error in is_line_commented: " .. tostring(result), vim.log.levels.DEBUG)
    return false
  end

  return result
end

return M
