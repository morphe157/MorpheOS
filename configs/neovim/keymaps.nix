{
  keymaps = [
    {
      mode = "n";
      key = "<space>[";
      options.silent = true;
      options.desc = "[Telescope] find files";
      options.noremap = true;
      action = "<cmd>Telescope find_files<CR>";
    }
    {
      mode = "n";
      key = "<space>]";
      options.silent = true;
      options.desc = "[Telescope] keymaps";
      options.noremap = true;
      action = "<cmd>Telescope keymaps<CR>";
    }
    {
      mode = "n";
      key = "<space>'";
      options.silent = true;
      options.desc = "[Telescope] live grep";
      options.noremap = true;
      action = "<cmd>Telescope live_grep<CR>";
    }
    {
      mode = "n";
      key = "<space>;";
      options.silent = true;
      options.desc = "[Telescope] buffers";
      options.noremap = true;
      action = "<cmd>Telescope buffers<CR>";
    }
    {
      mode = "n";
      key = "<space>.";
      options.silent = true;
      options.desc = "[Telescope] git files";
      options.noremap = true;
      action = "<cmd>Telescope git_files<CR>";
    }
    {
      mode = "n";
      key = "N";
      options.silent = true;
      options.desc = "[Oil] open float";
      options.noremap = true;
      action = "<cmd>lua require('oil').open_float()<CR>";
    }
    {
      mode = "n";
      key = "<C-d>";
      options.silent = true;
      options.desc = "Center page down";
      options.noremap = true;
      action = "<C-d>zz";
    }
    {
      mode = "n";
      key = "<C-u>";
      options.silent = true;
      options.desc = "Center page up";
      options.noremap = true;
      action = "<C-u>zz";
    }
    {
      mode = "n";
      key = "<Space>m";
      options.silent = true;
      options.desc = "[Lspsaga] Open workspace diagnostic";
      options.noremap = true;
      action = "<cmd>Lspsaga show_workspace_diagnostics<CR>";
    }
    {
      mode = "n";
      key = "<Space>o";
      options.silent = true;
      options.desc = "[RustLsp] Open web doc in browser";
      options.noremap = true;
      action = "<cmd>RustLsp externalDocs<CR>";
    }
    {
      mode = "n";
      key = "<Space>n";
      options.silent = true;
      options.desc = "[Lspsaga] Next diagnostic";
      options.noremap = true;
      action = "<cmd>Lspsaga diagnostic_jump_next<CR>";
    }
    {
      mode = "n";
      key = "<Space>p";
      options.silent = true;
      options.desc = "[Lspsaga] Prev diagnostic";
      options.noremap = true;
      action = "<cmd>Lspsaga diagnostic_jump_prev<CR>";
    }
    {
      mode = "n";
      key = "<Space>a";
      options.silent = true;
      options.desc = "[Lspsaga] Code action";
      options.noremap = true;
      action = "<cmd>Lspsaga code_action<CR>";
    }
    {
      mode = "n";
      key = "<C-t>";
      options.silent = true;
      options.desc = "[Lspsaga] Toggle terminal";
      options.noremap = true;
      action = "<cmd>Lspsaga term_toggle<CR>";
    }
    {
      mode = "t";
      key = "<C-t>";
      options.silent = true;
      options.desc = "[Lspsaga] Toggle terminal";
      options.noremap = true;
      action = "<cmd>Lspsaga term_toggle<CR>";
    }
    {
      mode = "n";
      key = "<Space>r";
      options.silent = true;
      options.desc = "[Lspsaga] Rename";
      options.noremap = true;
      action = "<cmd>Lspsaga rename<CR>";
    }
    {
      mode = "n";
      key = "K";
      options.silent = true;
      options.desc = "[Lspsaga] Hover";
      options.noremap = true;
      action = "<cmd>Lspsaga hover_doc<CR>";
    }
    {
      mode = "n";
      key = "<Space>f";
      options.silent = true;
      options.desc = "[LSP] Format";
      options.noremap = true;
      action = "<cmd>lua require('conform').format()<CR>";
    }
    {
      mode = "n";
      key = "<Space>dc";
      options.silent = true;
      options.desc = "[DAP] Continue";
      options.noremap = true;
      action = "<cmd>DapContinue<CR>";
    }
    {
      mode = "n";
      key = "<Space>db";
      options.silent = true;
      options.desc = "[DAP] Toggle breakpoint";
      options.noremap = true;
      action = "<cmd>DapToggleBreakpoint<CR>";
    }
  ];
}
