local dap = require 'dap'

dap.configurations.cpp = {
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
