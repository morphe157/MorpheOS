{
  plugins = {
    dap = {
      enable = true;
      lazyLoad.settings.cmd = [
        "DapContinue"
        "DapToggleBreakpoint"
        "DapStepOver"
        "DapStepInto"
        "DapStepOut"
        "DapTerminate"
      ];
      adapters.servers.lldb = {
        port = "\${port}";
        executable = {
          command = "codelldb";
          args = [
            "--port"
            "\${port}"
          ];
        };
      };
      configurations.rust = [
        {
          type = "lldb";
          request = "launch";
          name = "Debug (Main)";
          sourceLanguages = [ "rust" ];
          program = {
            __raw = ''
              function()
                 local cwd = string.format("%s%s", vim.fn.getcwd(), sep)
                 return vim.fn.input("Path to executable: ", cwd, "file")
              end
            '';
          };
          stopOnEntry = false;
        }
      ];
    };
    dap-ui = {
      enable = true;
      lazyLoad.settings = {
        cmd = [
          "DapUiToggle"
          "DapUiOpen"
          "DapUiClose"
          "DapUiFloatElement"
        ];
      };
    };
  };
}
