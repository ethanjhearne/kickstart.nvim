local escape_punctuation = function(str)
  return str:gsub('%p', '%%%1')
end

local get_fragment_identifier = function(opts)
  if opts.line1 == opts.line2 then
    return '#L' .. opts.line1
  end
  return '#L' .. opts.line1 .. '-L' .. opts.line2
end

local trim = function(str)
  local result = str:gsub('^%s+', '')
  result = result:gsub('%s+$', '')
  return result
end

local found = function(str)
  return str ~= nil and str ~= ''
end

local goto_github = function(opts)
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
  if not found(url_to_repo) then
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

  local branch = call 'git branch --show-current'
  local url = url_to_repo .. '/blob/' .. branch .. '/' .. filepath .. get_fragment_identifier(opts)

  print('Opening... ' .. url)
  vim.ui.open(url)
end

vim.api.nvim_create_user_command('GotoGitHub', goto_github, { range = true })
vim.keymap.set('n', 'gh', ':GotoGitHub<CR>', { desc = '[G]o to this line on Git[H]ub' })
vim.keymap.set('x', 'gh', ":'<,'>GotoGitHub<CR>", { desc = '[G]o to this line on Git[H]ub' })
