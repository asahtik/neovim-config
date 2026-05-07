vim.api.nvim_create_user_command('MiniDiffRef', function(opts)
  local commit = opts.args
  local file = vim.fn.expand('%')
  local git_root = vim.fn.systemlist({ 'git', 'rev-parse', '--show-toplevel' })[1]

  if vim.v.shell_error ~= 0 or git_root == nil then
    vim.notify('Not inside a Git repository', vim.log.levels.ERROR)
    return
  end

  local rel_file = vim.fn.fnamemodify(file, ':p'):sub(#git_root + 2)
  local ref = commit .. ':' .. rel_file
  local text = vim.fn.system({ 'git', 'show', ref })

  if vim.v.shell_error ~= 0 then
    vim.notify('Could not read ' .. ref, vim.log.levels.ERROR)
    return
  end

  MiniDiff.set_ref_text(0, text)

  vim.notify('mini.diff reference set to ' .. commit)
end, {
  nargs = 1,
  complete = function()
    return vim.fn.systemlist({
      'git',
      'for-each-ref',
      '--format=%(refname:short)',
      'refs/heads',
      'refs/remotes',
      'refs/tags',
    })
  end,
})

vim.api.nvim_create_user_command('MiniDiffFile', function(opts)
  local file = vim.fn.expand(opts.args)

  if vim.fn.filereadable(file) == 0 then
    vim.notify('File not found: ' .. file, vim.log.levels.ERROR)
    return
  end

  local lines = vim.fn.readfile(file)
  local text = table.concat(lines, '\n')

  -- Preserve trailing newline if present
  if vim.fn.getfsize(file) > 0 then
    local last = vim.fn.readfile(file, '', 1)[1]
    if last == '' then
      text = text .. '\n'
    end
  end

  MiniDiff.set_ref_text(0, text)

  vim.notify('mini.diff reference set to ' .. file)
end, {
  nargs = 1,
  complete = 'file',
})

vim.api.nvim_create_user_command('MiniDiffUnsaved', function()
  local file = vim.fn.expand('%:p')

  if file == '' or vim.fn.filereadable(file) == 0 then
    MiniDiff.set_ref_text(0, '')
    vim.notify('Current buffer has no saved file', vim.log.levels.ERROR)
    return
  end

  local lines = vim.fn.readfile(file)
  local text = table.concat(lines, '\n')

  -- Preserve trailing newline
  local f = io.open(file, 'rb')
  if f then
    local content = f:read('*a')
    f:close()

    if content:sub(-1) == '\n' then
      text = text .. '\n'
    end
  end

  MiniDiff.set_ref_text(0, text)

  vim.notify('mini.diff reference set to saved file')
end, {})

vim.api.nvim_create_user_command('MiniDiffReset', function()
  MiniDiff.disable()
  MiniDiff.enable()

  vim.notify('mini.diff reset')
end, {})
