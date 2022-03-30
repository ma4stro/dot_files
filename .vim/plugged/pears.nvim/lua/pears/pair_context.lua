local PearTree = require "pears.pear_tree"
local MarkedRange = require "pears.marked_range"
local Utils = require "pears.utils"

local PairContext = {}

function PairContext.new(branch, range, bufnr)
  local self = {
    id = math.random(10000),
    top_branch = branch,
    bufnr = bufnr,
    trie = nil,
    branch = branch,
    leaf = branch.leaf,
    range = MarkedRange.new(bufnr, range),
    expansions = {},
    chars = {}
  }

  return setmetatable(self, {__index = PairContext})
end

function PairContext:get_text(position)
  if not self.range:is_marked() then return end

  if position then
    local start = self.range:start()

    return Utils.get_content_from_range(self.bufnr, {start[1], start[2], position[1], position[2]})
  else
    return Utils.get_content_from_range(self.bufnr, self.range:range())
  end
end

function PairContext:_check_previous_chars(char, position)
  local range_text = self:get_text(position)

  if range_text then
    range_text = table.concat(range_text, "\n")

    for i = #self.chars, 1, -1 do
      local last_char = self.chars[i]
      local char_index = #range_text - (#self.chars - i)
      local actual_char = string.sub(range_text, char_index, char_index)

      if actual_char ~= last_char then
        return false
      end
    end
  end

  return true
end

function PairContext:step_forward(chars, position)
  local did_step = false
  local done = true

  for i = 1, #chars, 1 do
    local char = string.sub(chars, i, i)
    local key = PearTree.make_key(char)

    if self.branch.branches and self.branch.branches[key] and self:_check_previous_chars(char, position) then
      table.insert(self.chars, char)
      self.branch = self.branch.branches[key]
      self.leaf = self.branch.leaf or self.branch.wildcard
      did_step = true
      done = false
    else
      local wildcard = self:_get_nearest_wildcard()

      self.leaf = wildcard

      if wildcard then
        did_step = false
        done = false
      else
        did_step = false
        done = true
      end

      break
    end
  end

  return {did_step = did_step, done = done}
end

function PairContext:step_backward()
  if self.branch and self.branch.parent and not self:at_start() then
    table.remove(self.chars)
    self.branch = self.branch.parent
    self.leaf = self.branch.leaf or self:_get_nearest_wildcard()
  end
end

function PairContext:tag_expansion()
  if self.leaf then
    table.insert(self.expansions, self.leaf)
  end
end

function PairContext:get_last_expansion()
  return self.expansions[#self.expansions]
end

function PairContext:at_end()
  return self.branch and vim.tbl_isempty(self.branch.branches)
end

function PairContext:at_start()
  return self.branch == self.top_branch
end

function PairContext:destroy()
  self.range:unmark()
end

function PairContext:_get_nearest_wildcard()
  local current = self.branch

  while current do
    if current.wildcard then
      break
    end

    current = current.parent
  end

  return (current and current.wildcard) or nil
end

return PairContext
