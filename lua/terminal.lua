vim.keymap.set('n', '<leader>t', ':term<CR>', { desc = 'Open [t]erminal' })

local function comma_separated_filter(func, csl)
  local tbl = vim.split(csl, ',')
  local new_tbl = vim.tbl_filter(func, tbl)
  return table.concat(new_tbl, ',')
end

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

define_term_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = define_term_highlights,
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.cmd.startinsert()
  end,
})

vim.api.nvim_create_autocmd('TermEnter', {
  group = vim.api.nvim_create_augroup('custom-term-enter', { clear = true }),
  callback = function()
    vim.api.nvim_set_option_value('winhighlight', 'Normal:TermNormal', { win = 0 })
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd('TermLeave', {
  group = vim.api.nvim_create_augroup('custom-term-leave', { clear = true }),

  -- This pattern is important because when exiting a terminal session, the
  -- window is automatically closed and the TermLeave event fires on the
  -- **newly-entered** buffer!
  --
  -- This is still technically incorrect, because it'll still trigger if the
  -- new buffer is also a terminal buffer. However because I don't enter insert
  -- mode automatically when re-entering a terminal buffer, it has no visible
  -- effect (the terminal buffer should already be in the dimmed state)
  pattern = 'term://*',

  callback = function(ev)
    vim.print(ev)
    vim.api.nvim_set_option_value('winhighlight', 'Normal:TermDim', { win = 0 })
    vim.opt.number = true
    vim.opt.relativenumber = true
  end,
})

-- Whenever we enter a non-terminal buffer, clean up after ourselves by
-- removing the custom terminal highlighting (if it exists)
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('custom-buf-enter', { clear = true }),
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= 'terminal' then
      local hl = vim.api.nvim_get_option_value('winhighlight', {})

      local new_hl = comma_separated_filter(function(v)
        return v ~= 'Normal:TermNormal' and v ~= 'Normal:TermDim'
      end, hl)

      vim.api.nvim_set_option_value('winhighlight', new_hl, {})
    end
  end,
})

-- Just a reminder that you can also use  `pattern` on a generic Buf... event
-- vim.api.nvim_create_autocmd( 'BufEnter' , {
--   pattern = 'term://*',
-- })
