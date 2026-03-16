return {
  'saghen/blink.cmp',
  opts = {
    keymap = {
      preset = 'default',
      ['<Tab>'] = { 'accept', 'fallback' },
      ['<C-.>'] = { 'show', 'accept', 'fallback' },
      ['<C-Space>'] = { 'show', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
    },
    completion = {
      trigger = {
        show_on_insert_on_trigger_character = false,
        show_on_keyword = false,
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },
}
