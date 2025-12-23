local helpers = {}

local Terminal = require("toggleterm.terminal").Terminal
local opencode_terminal = Terminal:new({
  cmd = "opencode",
  hidden = true,
  display_name = "OpenCode",
  direction = "float",
  on_open = function(term)
    vim.cmd("startinsert!")
  end,
})
function helpers.toggle_opencode_terminal()
  opencode_terminal:toggle()
end

-- Set the current relative filepath in the clipboard
function helpers.copy_relative_filepath()
  local filepath = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
  vim.fn.setreg('+', filepath)
  print('Copied relative filepath: ' .. filepath)
end

--- Delete all installed packs
function helpers.delete_all_pack()
  local pack_specs = vim.pack.get()
  local pack_name_tbl = {}
  for _, pack in ipairs(pack_specs) do
    table.insert(pack_name_tbl, pack.spec.name)
  end
  vim.pack.del(pack_name_tbl)
end

return helpers
