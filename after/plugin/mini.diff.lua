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
