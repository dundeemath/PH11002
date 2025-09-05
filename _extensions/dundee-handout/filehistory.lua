local function wrap_env(env, blocks)
  local open  = pandoc.RawBlock('latex', '\\begin{' .. env .. '}')
  local close = pandoc.RawBlock('latex', '\\end{' .. env .. '}')
  local out = { open }
  for i = 1, #blocks do out[#out+1] = blocks[i] end
  out[#out+1] = close
  return out
end

local function label_inline()
  -- bold, sans, gray label + a small space
  return pandoc.RawInline('latex', '{\\sffamily\\bfseries\\color{gray}Filehistory:}\\enspace ')
end

function Div(el)
  local env = nil
  if el.classes:includes('filehistory') then
    env = 'filehistory'
  elseif el.classes:includes('filehistorybottom') then
    env = 'filehistorybottom'
  end
  if not env then return nil end

  -- Ensure the first block starts with the label inline
  if #el.content > 0 and el.content[1].t == 'Para' then
    table.insert(el.content[1].content, 1, label_inline())
  elseif #el.content > 0 and el.content[1].t == 'Plain' then
    table.insert(el.content[1].content, 1, label_inline())
  else
    -- No paragraph up front; create one containing just the label
    table.insert(el.content, 1, pandoc.Para({ label_inline() }))
  end

  -- Wrap the whole thing in the LaTeX environment
  return wrap_env(env, el.content)
end