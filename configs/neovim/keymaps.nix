{
  keymaps = [
    {
      mode = "n";
      key = "<Space>w";
      options.silent = true;
      options.desc = "Write all";
      options.noremap = true;
      action = "<cmd>wa<CR>";
    }
    {
      mode = "n";
      key = "<C-q>";
      options.silent = true;
      options.desc = "Write all and quit";
      options.noremap = true;
      action = "<cmd>wq<CR>";
    }
    {
      mode = "n";
      key = "<Space>q";
      options.silent = true;
      options.desc = "Write all and quit";
      options.noremap = true;
      action = "<cmd>wq<CR>";
    }
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
      key = "<C-]>";
      options.silent = true;
      options.desc = "[Lspsaga] Go to definition";
      options.noremap = true;
      action = "<cmd>Lspsaga goto_definition<CR>";
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
      action = "<cmd>lua vim.lsp.buf.format()<CR>";
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
    {
      mode = "n";
      key = "<Space>dB";
      options.silent = true;
      options.desc = "[DAP] Toggle conditional breakpoint";
      options.noremap = true;
      action = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Condition: '))<CR>";
    }
    {
      mode = "i";
      key = "<C-]>";
      options.silent = true;
      options.desc = "[Copilot] Accept line";
      options.noremap = true;
      action = "<cmd>Copilot suggestion accept<CR>";
    }
    {
      mode = "n";
      key = "<Tab>";
      options.silent = true;
      options.desc = "[Bar] Buffer Next";
      options.noremap = true;
      action = "<cmd>BufferNext<CR>";
    }
    {
      mode = "n";
      key = "<S-Tab>";
      options.silent = true;
      options.desc = "[Bar] Buffer Prev";
      options.noremap = true;
      action = "<cmd>BufferPrevious<CR>";
    }
    {
      mode = "n";
      key = "<Space>c";
      options.silent = true;
      options.desc = "[Bar] Buffer Close";
      options.noremap = true;
      action = "<cmd>BufferClose<CR>";
    }
    {
      mode = "n";
      key = "<Space>b";
      options.silent = true;
      options.desc = "[Bar] Buffer Pick";
      options.noremap = true;
      action = "<cmd>BufferPick<CR>";
    }
    {
      mode = "n";
      key = "<Space>B";
      options.silent = true;
      options.desc = "[Bar] Buffer Pick Delete";
      options.noremap = true;
      action = "<cmd>BufferPickDelete<CR>";
    }
    {
      mode = "n";
      key = "<Space>bb";
      options.silent = true;
      options.desc = "[Bar] Buffer Close All But Current";
      options.noremap = true;
      action = "<cmd>BufferCloseAllButCurrent<CR>";
    }
    {
      mode = "n";
      key = "<space>1";
      options.silent = true;
      options.desc = "[Bar] Buffer Goto 1";
      options.noremap = true;
      action = "<cmd>BufferGoto 1<CR>";
    }
    {
      mode = "n";
      key = "<space>2";
      options.silent = true;
      options.desc = "[Bar] Buffer Goto 2";
      options.noremap = true;
      action = "<cmd>BufferGoto 2<CR>";
    }
    {
      mode = "n";
      key = "<space>3";
      options.silent = true;
      options.desc = "[Bar] Buffer Goto 3";
      options.noremap = true;
      action = "<cmd>BufferGoto 3<CR>";
    }
    {
      mode = "n";
      key = "<space>4";
      options.silent = true;
      options.desc = "[Bar] Buffer Goto 4";
      options.noremap = true;
      action = "<cmd>BufferGoto 4<CR>";
    }
    {
      mode = "n";
      key = "<space>5";
      options.silent = true;
      options.desc = "[Bar] Buffer Goto 5";
      options.noremap = true;
      action = "<cmd>BufferGoto 5<CR>";
    }
    {
      mode = "n";
      key = "<space>6";
      options.silent = true;
      options.desc = "[Bar] Buffer Goto 6";
      options.noremap = true;
      action = "<cmd>BufferGoto 6<CR>";
    }
  ];
}
