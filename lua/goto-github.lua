local escape_punctuation = function(str)
  return str:gsub('%p', '%%%1')
end

local get_fragment_identifier = function()
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'n' then
    local cursorPosition = vim.api.nvim_win_get_cursor(0)
    return '#L' .. cursorPosition[1]
  end
  if mode == 'v' then
    local startPos = vim.fn.getpos "'<"
    local startLine = startPos[2]
    local endPos = vim.fn.getpos "'>"
    local endLine = endPos[2]
    return '#L' .. startLine .. '-' .. 'L' .. endLine
  end
  return ''
end

local trim = function(str)
  local result = str:gsub('^%s+', '')
  result = result:gsub('%s+$', '')
  return result
end

local found = function(str)
  return str ~= nil and str ~= ''
end

local goto_github = function()
  local err = vim.api.nvim_err_writeln
  local call = function(cmd)
    return trim(vim.fn.system(cmd))
  end

  local origin_url = call 'git config --get remote.origin.url'
  if not found(origin_url) then
    err "Couldn't find a git origin URL (do you need to :cd ?)"
    return
  end

  -- Look for HTTPS format URL
  local url_to_repo = origin_url:match '^(https://.*)%.git$'
  if not url_to_repo then
    -- Look for username@domain.com:repo_name.git (SSH format)
    local domain, repo_name = origin_url:match '^.+@(.+):(.+)%.git$'
    if found(domain) and found(repo_name) then
      -- Build HTTPS URL from the git URL pieces
      url_to_repo = 'https://' .. domain .. '/' .. repo_name
    else
      err("Couldn't parse the git origin URL: " .. origin_url)
      return
    end
  end

  local local_repo_path = call 'git rev-parse --show-toplevel'
  local local_filepath = vim.fn.expand '%:p'
  local pattern = '^' .. escape_punctuation(local_repo_path) .. '/(.*)$'
  local filepath = local_filepath:match(pattern)
  if not found(filepath) then
    err "This file isn't in the current git directory (do you need to :cd ?)"
    return
  end

  -- https://github.com/ethanjhearne/kickstart.nvim/blob/master/lua/autocommands.lua
  local branch = call 'git branch --show-current'
  local url = url_to_repo .. '/blob/' .. branch .. '/' .. filepath .. get_fragment_identifier()

  print('Opening... ' .. url)
  -- Old way:
  -- vim.fn.system('open ' .. url)
  vim.ui.open(url)
end
vim.keymap.set('n', 'gh', goto_github, { desc = '[G]o to this line on Git[H]ub' })
