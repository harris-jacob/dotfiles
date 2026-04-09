local dap_breakpoint = {
    error = {
        text = "🟥",
        texthl = "LspDiagnosticsSignError",
        linehl = "",
        numhl = "",
    },
    rejected = {
        text = "",
        texthl = "LspDiagnosticsSignHint",
        linehl = "",
        numhl = "",
    },
    stopped = {
        text = "⭐️",
        texthl = "LspDiagnosticsSignInformation",
        linehl = "DiagnosticUnderlineInfo",
        numhl = "LspDiagnosticsSignInformation",
    },
}

vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

require("nvim-dap-virtual-text").setup()
require('dap-go').setup()
require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Keymaps
vim.keymap.set("n", "<F5>",       function() require('dap').continue() end,                                          { desc = "DAP: Continue" })
vim.keymap.set("n", "<F3>",       function() require('dap').step_over() end,                                         { desc = "DAP: Step Over" })
vim.keymap.set("n", "<F2>",       function() require('dap').step_into() end,                                         { desc = "DAP: Step Into" })
vim.keymap.set("n", "<F12>",      function() require('dap').step_out() end,                                          { desc = "DAP: Step Out" })
vim.keymap.set("n", "<leader>b",  function() require('dap').toggle_breakpoint() end,                                 { desc = "DAP: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>B",  function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "DAP: Set Breakpoint" })
vim.keymap.set("n", "<leader>lp", function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = "DAP: Log Point" })
vim.keymap.set("n", "<leader>dr", function() require('dap').repl.open() end,                                         { desc = "DAP: Open REPL" })
vim.keymap.set("n", "<leader>dt", function() require('dap-go').debug_test() end,                                     { desc = "DAP: Debug Test" })
