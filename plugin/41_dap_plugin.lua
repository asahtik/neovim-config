local add = vim.pack.add
local now_if_args, later = Config.now_if_args, Config.later

-- debugging tools
later(function()
  add({ 'https://github.com/mfussenegger/nvim-dap' })
  add({ 'https://github.com/nvim-neotest/nvim-nio' })
  add({ 'https://github.com/rcarriga/nvim-dap-ui' })
  add({ 'https://github.com/jay-babu/mason-nvim-dap.nvim' })

  vim.keymap.set('n', '<F5>', function()
    require('dap').continue()
  end)
  vim.keymap.set('n', '<F10>', function()
    require('dap').step_over()
  end)
  vim.keymap.set('n', '<F11>', function()
    require('dap').step_into()
  end)
  vim.keymap.set('n', '<F12>', function()
    require('dap').step_out()
  end)
  vim.keymap.set('n', '<Leader>db', function()
    require('dap').toggle_breakpoint()
  end)
  vim.keymap.set('n', '<Leader>dB', function()
    require('dap').set_breakpoint()
  end)
  vim.keymap.set('n', '<Leader>dlp', function()
    require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
  end)
  vim.keymap.set('n', '<Leader>dr', function()
    require('dap').repl.open()
  end)
  vim.keymap.set('n', '<Leader>dl', function()
    require('dap').run_last()
  end)
  vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
    require('dap.ui.widgets').hover()
  end)
  vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
    require('dap.ui.widgets').preview()
  end)
  vim.keymap.set('n', '<Leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
  end)
  vim.keymap.set('n', '<Leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
  end)

  require('dap').configurations.cpp = {
    {
      name = 'Launch file',
      type = 'cppdbg',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
      cwd = '${workspaceFolder}',
      stopAtEntry = true,
    },
    {
      name = 'Attach to gdbserver hostname:port',
      type = 'cppdbg',
      request = 'launch',
      MIMode = 'gdb',
      miDebuggerServerAddress = function()
        return vim.fn.input 'GDB server address: '
        end,
      miDebuggerPath = '/usr/bin/gdb',
      cwd = '${workspaceFolder}',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
    },
    {
      name = 'Debug core dump',
      type = 'cppdbg',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
      coreDumpPath = function()
        return vim.fn.input('Path to core dump: ', vim.fn.getcwd() .. '/', 'file')
        end,
      MIMode = 'gdb',
      miDebuggerPath = os.getenv 'GDB' or 'gdb',
      setupCommands = {
        {
          description = 'Enable GDB pretty printing',
          text = '-enable-pretty-printing',
          ignoreFailures = false,
        },
        {
          description = 'Set sysroot',
          text = function()
            return '-gdb-set sysroot ' .. vim.fn.input('Path to sysroot: ', '', 'file')
            end,
        },
      },
      cwd = '${workspaceFolder}',
      stopAtEntry = true,
    },
  }
end)
