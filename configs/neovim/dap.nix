{
  plugins.dap = {
    enable = true;

    adapters = {
      servers.codelldb = {
        port = 13000;
        executable = {
          command = "codelldb";
          args = [
            "--port"
            "13000"
          ];
        };
      };
    };

    configurations = {
      rust = [
        {
          name = "rust";
          type = "codelldb";
          request = "launch";
          cwd = "\${workspaceFolder}";
          program.__raw = ''
            function()
              return vim.fn.input('Executable path: ', vim.fn.getcwd() .. '/', 'file')
            end
          '';
        }
      ];
    };
    extensions = {
      dap-ui.enable = true;
      dap-virtual-text.enable = true;
    };
  };
  extraConfigLua = ''
    require('dap').listeners.after.event_initialized['dapui_config'] = require('dapui').open
    require('dap').listeners.before.event_terminated['dapui_config'] = require('dapui').close
    require('dap').listeners.before.event_exited['dapui_config'] = require('dapui').close
  '';
}
