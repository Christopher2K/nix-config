local usercmd = {}

function usercmd.init()
  local fns = require('fns')


  vim.api.nvim_create_user_command('CopyRelativeFilepath', fns.copy_relative_filepath, {})
  vim.api.nvim_create_user_command('DelAllPack', fns.delete_all_pack, {})
  vim.api.nvim_create_user_command('ToggleOpenCode', fns.toggle_opencode_terminal, {})
  vim.api.nvim_create_user_command('ToggleCentered', require("stay-centered").toggle, {})
end

return usercmd
