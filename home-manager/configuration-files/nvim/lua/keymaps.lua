local keys = {}
-- INFO:
-- Plugin specific keymaps are under their respective file in plugins/*

function keys.init()
  -- No arrow key allowed
  vim.keymap.set("n", "<up>", "<nop>", { silent = true })
  vim.keymap.set("n", "<down>", "<nop>", { silent = true })
  vim.keymap.set("n", "<left>", "<nop>", { silent = true })
  vim.keymap.set("n", "<right>", "<nop>", { silent = true })
  -- Remove macro key since I don't use it
  vim.keymap.set("n", "q", "<nop>", { silent = true })
  -- Clear search with <esc>
  vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch", silent = true })
  -- Save
  vim.keymap.set("n", "<C-S>", "<CMD>w<CR>", { silent = true, desc = "Save file" })
  -- Window cursor movement
  vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", silent = true })
  vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", silent = true })
  vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", silent = true })
  vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", silent = true })
  -- Resize window
  vim.keymap.set("n", "<S-Up>", "<CMD>resize +2<CR>", { desc = "Increase window height", silent = true })
  vim.keymap.set("n", "<S-Down>", "<CMD>resize -2<CR>", { desc = "Decrease window height", silent = true })
  vim.keymap.set("n", "<S-Left>", "<CMD>vertical resize -2<CR>", { desc = "Decrease window width", silent = true })
  vim.keymap.set("n", "<S-Right>", "<CMD>vertical resize +2<CR>", { desc = "Increase window width", silent = true })
  -- Others
  vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete window", silent = true })
  vim.keymap.set("n", "<leader>wy", "<C-W>s", { desc = "Split window below", silent = true })
  vim.keymap.set("n", "<leader>wx", "<C-W>v", { desc = "Split window right", silent = true })
  -- Tab
  vim.keymap.set("n", "<leader>tt", "<CMD>tabnew<CR>", { desc = "New Tab", silent = true })
  vim.keymap.set("n", "<leader>td", "<CMD>tabclose<CR>", { desc = "Close Tab", silent = true })
  vim.keymap.set("n", "<S-h>", "<CMD>tabnext<CR>", { desc = "Next tab", silent = true })
  vim.keymap.set("n", "<S-l>", "<CMD>tabprev<CR>", { desc = "Prev tab", silent = true })
  -- Move lines
  vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line up", silent = true })
  vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line down", silent = true })

  -- Lsp related keymaps
  vim.keymap.set("n", "ge", vim.diagnostic.open_float, { desc = "Open diagnostic popup" })
  vim.keymap.set("n", "[d",
    function()
      vim.diagnostic.jump({ count = -1, float = true })
    end,
    { desc = "Go to previous diagnostic" }
  )
  vim.keymap.set("n", "]d",
    function()
      vim.diagnostic.jump({ count = 1, float = true })
    end,
    { desc = "Go to next diagnostic" }
  )
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
  vim.keymap.set("n", "<leader>wl",
    function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { desc = "List workspace folders" }
  )
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
  vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Check references" })

  -- Plugins stuff
  vim.keymap.set("n", "<leader>e", "<cmd>Neotree reveal<cr>", { desc = "Open or focus explorer" })
  vim.keymap.set("n", "<leader>b", "<cmd>Neotree close<cr>", { desc = "Close explorer" })

  vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Open LazyGit" })
  vim.keymap.set("n", "<leader>i", "<cmd>Sleuth<cr>", { desc = "Fix indentiation" })

  -- File picker
  local pick = require("mini.pick")

  vim.keymap.set("n", "<leader>ff",
    function()
      return pick.builtin.files({})
    end,
    { desc = "Pick file" }
  )
  vim.keymap.set("n", "<leader>fb",
    function()
      pick.builtin.buffers({})
    end,
    { desc = "Pick buffer" }
  )
  vim.keymap.set("n", "<leader>fg",
    function()
      pick.builtin.grep_live({})
    end,
    { desc = "Pick live grep" }
  )
  vim.keymap.set('n', '<leader>fw', '<cmd>Pick git_worktrees<cr>')

  -- Terminal
  function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  end

  vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

  -- OpenCode Terminal (ToggleTerm)
  vim.keymap.set({ "n", "t" }, "<C-x>", function() _toggle_opencode() end, { desc = "Toggle OpenCode terminal" })
end

return keys
