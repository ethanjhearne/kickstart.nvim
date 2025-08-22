local escape_punctuation = function(str)
  return str:gsub('%p', '%%%1')
end

local get_line_number = function()
  local cursorPosition = vim.api.nvim_win_get_cursor(0)
  return cursorPosition[1]
end

local trim = function(str)
  local result = str:gsub('^%s+', '')
  result = result:gsub('%s+$', '')
  return result
end

local not_found = function(str)
  return str == nil or str == ''
end

local goto_github = function()
  local err = vim.api.nvim_err_writeln
  local call = function(cmd)
    return trim(vim.fn.system(cmd))
  end

  local origin_url = call 'git config --get remote.origin.url'
  if not_found(origin_url) then
    err "Couldn't find a git origin URL (do you need to :cd ?)"
    return
  end

  local domain, repo_name = origin_url:match '^.+@(.+):(.+)%.git$'
  if not_found(domain) or not_found(repo_name) then
    err("Couldn't parse the git origin URL (do you need to convert to SSH?): " .. origin_url)
    return
  end

  local local_repo_path = call 'git rev-parse --show-toplevel'
  local local_filepath = vim.fn.expand '%:p'
  local pattern = '^' .. escape_punctuation(local_repo_path) .. '/(.*)$'
  local filepath = local_filepath:match(pattern)
  if not_found(filepath) then
    err "This file isn't in the current git directory (do you need to :cd ?)"
    return
  end

  local branch = call 'git branch --show-current'
  local url = 'https://' .. domain .. '/' .. repo_name .. '/blob/' .. branch .. '/' .. filepath .. '#L' .. get_line_number()

  print('Opening... ' .. url)
  -- Old way:
  -- vim.fn.system('open ' .. url)
  vim.ui.open(url)
end
vim.keymap.set('n', 'gh', goto_github, { desc = '[G]o to this line on Git[H]ub' })
