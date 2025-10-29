local map = vim.keymap.set

-- 🚀 Ctrl+P opens Telescope file picker
map('n', '<C-p>', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })

-- 📁 <leader>ff also opens file picker
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })

-- 📑 <leader>fb opens buffer list (switch between open files)
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Buffers' })
