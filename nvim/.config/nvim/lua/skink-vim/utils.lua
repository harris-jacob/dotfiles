local M = {}

function M.merge_tables(...)
  local tables = { ... }
  local merged = {}

  for _, t in ipairs(tables) do
    for k, v in pairs(t) do
      merged[k] = v
    end
  end

  return merged
end

function M.with_desc(table, desc)
  return M.merge_tables(table, { desc = desc })
end

return M
