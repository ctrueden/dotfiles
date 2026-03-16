return {
  'saghen/blink.cmp',
  opts = {
    keymap = {
      preset = 'default',
      ['<Tab>'] = { 'accept', 'fallback' },
      ['<C-.>'] = { 'show', 'accept', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },
}
