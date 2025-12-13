local M = {}

-- Global-ish history table, per-buffer
local history = {}

-- --- Helpers ---------------------------------------------------------------

local function get_node(opts)
  opts = opts or {}
  local params = {
    bufnr = 0,
    ignore_injections = opts.ignore_injections,
    pos = opts.pos,
  }

  local ok, node = pcall(vim.treesitter.get_node, params)
  if not ok then
    return nil
  end
  return node
end

local function goto_node(node)
  local sr, sc = node:start()
  -- Neovim uses 1-based rows
  vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
end

local function current_stack()
  local bufnr = vim.api.nvim_get_current_buf()
  history[bufnr] = history[bufnr] or {}
  return history[bufnr]
end

-- Push current cursor position onto per-buffer stack
local function push_history()
  local stack = current_stack()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  table.insert(stack, { row, col })
end

local function pop_history()
  local stack = current_stack()
  if #stack == 0 then
    return nil
  end
  return table.remove(stack)
end

local function goto_pos(pos)
  vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] })
end

-- Find the "next outer" node that actually moves us earlier in the file.
local function find_parent_target()
  -- Node at cursor including injections (JSX/TSX, etc.)
  local node = get_node({ ignore_injections = false })
  if not node then
    return nil
  end

  local cur_sr, cur_sc = node:start()

  local tried_outer = false
  local candidate = node:parent()

  while true do
    if not candidate then
      if tried_outer then
        -- No more parents, nowhere to go
        return nil
      end

      -- At root of an injected tree? Try outer language tree.
      tried_outer = true
      local outer = get_node({
        ignore_injections = true,
        pos = { cur_sr, cur_sc },
      })

      if not outer or outer == node then
        return nil
      end

      candidate = outer
    end

    local psr, psc = candidate:start()

    -- Only accept a parent that starts earlier → visible "up" movement
    if psr < cur_sr or (psr == cur_sr and psc < cur_sc) then
      return candidate
    end

    candidate = candidate:parent()
  end
end

-- --- Public commands -------------------------------------------------------

-- Go up one structural level, recording where we came from
function M.goto_parent_with_history()
  local target = find_parent_target()
  if not target then
    return
  end

  -- save current cursor position before moving
  push_history()
  goto_node(target)
end

-- Go back to the last saved cursor position
function M.goto_prev_from_history()
  local pos = pop_history()
  if not pos then
    -- nothing to go back to
    return
  end

  goto_pos(pos)
end

return M
