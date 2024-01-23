-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)
return {
    -- NOTE: Yes, you can install new plugins here!
    'mfussenegger/nvim-dap',
    -- NOTE: And you can specify dependencies as well
    dependencies = { -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui', -- Installs the debug adapters for you
    'williamboman/mason.nvim', -- netcoredbg, vscode-js-debug(js-debug-adapter) are installed through mason
    'jay-babu/mason-nvim-dap.nvim', -- nvim-dap adapter for vscode-js-debug
    'leoluz/nvim-dap-go', 
    {
        'mxsdev/nvim-dap-vscode-js',
        config = function()
            require('dap-vscode-js').setup {
                -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
                debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", -- Path to vscode-js-debug installation.
                -- debugger_cmd = { "extension" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
                adapters = {'chrome', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost',
                            'node'} -- which adapters to register in nvim-dap
                -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
                -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
                -- log_console_level = vim.log.levels.ERROR -- Logging leve
            }

            local js_based_languages = {"typescript", "javascript", "typescriptreact"}
            for _, language in ipairs(js_based_languages) do
                require("dap").configurations[language] = {{
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}"
                }, {
                    type = "pwa-node",
                    request = "attach",
                    name = "Attach",
                    sourceMap = true,
                    port = 9222,
                    resolveSourceMapLocations = { "${workspaceFolder}/**","!**/node_modules/**"},
                    processId = require'dap.utils'.pick_process,
                    cwd = "${workspaceFolder}/src"
                }, {
                    type = "pwa-chrome",
                    request = "launch",
                    name = "Start Chrome with \"localhost\"",
                    port= 9222,
                    protocol='inspector',
                    soureMaps = true,
                    url = "http://localhost:44498",
                    webRoot = "${workspaceFolder}/src",
                    userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
                }}
            end
        end
    }},
    config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'

        dap.adapters["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
                command = "node",
                args = {vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}"}
            }
        }

        -- dap.configurations.javascript = {{
        --     type = "pwa-node",
        --     request = "launch",
        --     name = "Launch file",
        --     program = "${file}",
        --     cwd = "${workspaceFolder}"
        -- }, {
        --     type = "pwa-node",
        --     request = "attach",
        --     name = "Attach",
        --     processId = require'dap.utils'.pick_process,
        --     cwd = "${workspaceFolder}"
        -- }, {
        --     type = "pwa-chrome",
        --     request = "launch",
        --     name = "Start Chrome with \"localhost\"",
        --     url = "http://localhost:44498",
        --     webRoot = "${workspaceFolder}",
        --     userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
        -- }}

        require('mason-nvim-dap').setup {
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_setup = true,
            -- You can provide additional configuration to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {
                function(config)
                    -- all sources with no handler get passed here

                    -- Keep original functionality
                    require('mason-nvim-dap').default_setup(config)
                end,
                coreclr = function(config)
                	local path_to_netcoredbg = vim.fn.stdpath("data") .. '/mason/packages/netcoredbg/libexec/netcoredbg'
                	if vim.fn.has('win32')==1 then
                	    path_to_netcoredbg= vim.fn.stdpath("data") .. '/mason/packages/netcoredbg/netcoredbg/netcoredbg'
                	end
                    config.adapters = {
                        type = 'executable',
                        command = path_to_netcoredbg,
                        args = {'--interpreter=vscode'}
                    }
                    config.configurations.cs = {{
                        type = "coreclr",
                        name = "launch - netcoredbg",
                        request = "launch",
                        program = function()
                            if vim.fn.has('win32') == 1 then
                                return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/' .. vim.fn.expand('%:p:h:t') .. '/' .. '/bin/Debug/', 'file')
                            end
                            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')

                        end
                    }}
                    require('mason-nvim-dap').default_setup(config)
                end,
            },

            -- You'll need to check that you have the required things installed
            -- online, please don't ask me how to install them :)
            ensure_installed = { -- Update this to ensure that you have the debuggers for the langs you want
            'delve', 'coreclr',}
        }

        -- Basic debugging keymaps, feel free to change to your liking!
        vim.keymap.set('n', '<F5>', dap.continue, {
            desc = 'Debug: Start/Continue'
        })
        vim.keymap.set('n', '<F1>', dap.step_into, {
            desc = 'Debug: Step Into'
        })
        vim.keymap.set('n', '<F2>', dap.step_over, {
            desc = 'Debug: Step Over'
        })
        vim.keymap.set('n', '<F3>', dap.step_out, {
            desc = 'Debug: Step Out'
        })
        vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, {
            desc = 'Debug: Toggle Breakpoint'
        })
        vim.keymap.set('n', '<leader>B', function()
            dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end, {
            desc = 'Debug: Set Breakpoint'
        })

        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|
        dapui.setup {
            -- Set icons to characters that are more likely to work in every terminal.
            --    Feel free to remove or use ones that you like more! :)
            --    Don't feel like these are good choices.
            icons = {
                expanded = '▾',
                collapsed = '▸',
                current_frame = '*'
            },
            controls = {
                icons = {
                    pause = '⏸',
                    play = '▶',
                    step_into = '⏎',
                    step_over = '⏭',
                    step_out = '⏮',
                    step_back = 'b',
                    run_last = '▶▶',
                    terminate = '⏹',
                    disconnect = '⏏'
                }
            }
        }

        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
        vim.keymap.set('n', '<F7>', dapui.toggle, {
            desc = 'Debug: See last session result.'
        })

        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close

        -- Install golang specific config
        require('dap-go').setup()

    end
}
