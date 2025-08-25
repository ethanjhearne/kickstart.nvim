local function adjust_color(hex, factor)
  if not hex then
    return nil
  end
  hex = hex:gsub('#', '')
  local r = tonumber(hex:sub(1, 2), 16)
  local g = tonumber(hex:sub(3, 4), 16)
  local b = tonumber(hex:sub(5, 6), 16)

  -- move each channel toward mid-gray (128) by "factor"
  r = math.floor(r + (128 - r) * factor)
  g = math.floor(g + (128 - g) * factor)
  b = math.floor(b + (128 - b) * factor)

  return string.format('#%02x%02x%02x', r, g, b)
end

local function define_term_highlights()
  local normal_hl = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
  local fg = normal_hl.fg and string.format('#%06x', normal_hl.fg) or nil
  local bg = normal_hl.bg and string.format('#%06x', normal_hl.bg) or nil

  vim.api.nvim_set_hl(0, 'TermNormal', { fg = fg, bg = bg })
  vim.api.nvim_set_hl(0, 'TermDim', {
    fg = adjust_color(fg, 0.4),
    bg = adjust_color(bg, 0.05),
  })
end

vim.keymap.set('n', '<leader>t', ':term<CR>', { desc = 'Open [t]erminal' })
define_term_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = define_term_highlights,
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function(ev)
    vim.cmd.startinsert()

    vim.api.nvim_create_autocmd('TermEnter', {
      group = vim.api.nvim_create_augroup('custom-term-enter', { clear = true }),
      buffer = ev.buf,
      callback = function()
        vim.api.nvim_set_option_value('winhighlight', 'Normal:TermNormal', { scope = 'local' })
        vim.opt.number = false
        vim.opt.relativenumber = false
      end,
    })

    vim.api.nvim_create_autocmd('TermLeave', {
      group = vim.api.nvim_create_augroup('custom-term-leave', { clear = true }),
      -- Attaching to individual terminal buffers is important because it
      -- prevents TermLeave firing on a window that you've switched to after
      -- `exit`-ing a terminal session.
      buffer = ev.buf,
      callback = function()
        -- Local scope is important because it applies the highlight only when
        -- this buffer is shown in this window. Otherwise, loading a new buffer
        -- in the same window retains the dim effect.
        -- See :help local-options
        vim.api.nvim_set_option_value('winhighlight', 'Normal:TermDim', { scope = 'local' })
        vim.opt.number = true
        vim.opt.relativenumber = true
      end,
    })
  end,
})

-- Just a reminder that you can also use  `pattern` on a generic Buf... event
-- vim.api.nvim_create_autocmd( 'BufEnter' , {
--   pattern = 'term://*',
-- })
