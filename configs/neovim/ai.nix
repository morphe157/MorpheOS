{
  plugins.opencode = {
    enable = true;
    settings = {
    };
  };

  keymaps = [
    {
      mode = [
        "n"
        "x"
      ];
      key = "<C-a>";
      options = {
        silent = true;
        desc = "[AI] Opencode ask (submit)";
        noremap = true;
      };
      action = "<cmd>lua require('opencode').ask('@this: ', { submit = true })<CR>";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "<C-x>";
      options = {
        silent = true;
        desc = "[AI] Opencode select action";
        noremap = true;
      };
      action = "<cmd>lua require('opencode').select()<CR>";
    }
    {
      mode = [
        "n"
        "t"
        "x"
      ];
      key = "<space>,";
      options = {
        silent = true;
        desc = "[AI] Toggle Opencode";
        noremap = true;
      };
      action = "<cmd>lua require('opencode').toggle()<CR>";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "go";
      options = {
        desc = "[AI] Add range to opencode";
        expr = true;
        noremap = true;
      };
      action = "v:lua.require('opencode').operator('@this ')";
    }
    {
      mode = "n";
      key = "goo";
      options = {
        desc = "[AI] Add line to opencode";
        expr = true;
        noremap = true;
      };
      action = "v:lua.require('opencode').operator('@this ') .. '_'";
    }
  ];

  extraConfigLua = ''
    -- Required for `opts.events.reload` to work (opencode README recommendation).
    vim.o.autoread = true
  '';
}
