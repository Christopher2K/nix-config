local worktree_picker = {}

function worktree_picker.wt_switch(item)
  -- NOTE: Change CWD to selected item's path
  vim.schedule(function()
    vim.fn.chdir(item.path)
  end)
  vim.notify(
    'Git worktree changed to ' .. (item.branch and item.branch or '(bare)'),
    vim.log.levels.INFO
  )
end

--- @return { text: string, branch: string, path: string }[]
function worktree_picker.wt_postprocess(item)
  local items = {}
  for _, entry in pairs(vim.split(item[1], '%z%z', { trimempty = true })) do
    local path, head, _, ref =
        entry:match('^worktree (.-)%zHEAD (.-)%z([^ ]+) (.+)$')
    if path then
      local branch = vim.fs.basename(ref)
      items[#items + 1] = {
        text = string.format(
          '[%s] %s %s',
          branch,
          head:sub(1, 7),
          path
        ),
        branch = branch,
        path = path,
      }
    else
      path = entry:match('^worktree (.-)%z(bare)$')
      if path then
        items[#items + 1] = {
          text = string.format('(bare) %s', path),
          branch = nil,
          path = path,
        }
      end
    end
  end
  return items
end

return worktree_picker
