return {
  'gruvw/strudel.nvim',
  build = 'npm install',
  config = function()
    local strudel = require('strudel')
    strudel.setup()

    vim.keymap.set('n', '<leader>ml', strudel.launch, { desc = 'Launch Strudel' })
    vim.keymap.set('n', '<leader>mq', strudel.quit, { desc = 'Quit Strudel' })
    vim.keymap.set('n', '<leader>mt', strudel.toggle, { desc = 'Strudel Toggle Play/Stop' })
    vim.keymap.set('n', '<leader>mu', strudel.update, { desc = 'Strudel Update' })
    vim.keymap.set('n', '<leader>ms', strudel.stop, { desc = 'Strudel Stop Playback' })
    vim.keymap.set('n', '<leader>mb', strudel.set_buffer, { desc = 'Strudel set current buffer' })
    vim.keymap.set('n', '<leader>mx', strudel.execute, { desc = 'Strudel set current buffer and update' })
  end,
}
