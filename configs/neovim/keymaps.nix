{
  keymaps = [
    {
      mode = "n";
      key = "<Space>w";
      options = {
        silent = true;
        desc = "Write all";
        noremap = true;
      };
      action = "<cmd>wa<CR>";
    }
    {
      mode = "n";
      key = "<C-q>";
      options = {
        silent = true;
        desc = "Write all and quit";
        noremap = true;
      };
      action = "<cmd>wq<CR>";
    }
    {
      mode = "n";
      key = "<Space>q";
      options = {
        silent = true;
        desc = "Write all and quit";
        noremap = true;
      };
      action = "<cmd>wq<CR>";
    }
    {
      mode = "n";
      key = "<space>[";
      options = {
        silent = true;
        desc = "[Telescope] find files";
        noremap = true;
      };
      action = "<cmd>Telescope find_files<CR>";
    }
    {
      mode = "n";
      key = "<space>]";
      options = {
        silent = true;
        desc = "[Telescope] keymaps";
        noremap = true;
      };
      action = "<cmd>Telescope keymaps<CR>";
    }
    {
      mode = "n";
      key = "<space>'";
      options = {
        silent = true;
        desc = "[Telescope] live grep";
        noremap = true;
      };
      action = "<cmd>Telescope live_grep<CR>";
    }
    {
      mode = "n";
      key = "<space>;";
      options = {
        silent = true;
        desc = "[Telescope] buffers";
        noremap = true;
      };
      action = "<cmd>Telescope buffers<CR>";
    }
    {
      mode = "n";
      key = "<space>.";
      options = {
        silent = true;
        desc = "[Telescope] git files";
        noremap = true;
      };
      action = "<cmd>Telescope git_files<CR>";
    }
    {
      mode = "n";
      key = "N";
      options = {
        silent = true;
        desc = "[Oil] open float";
        noremap = true;
      };
      action = "<cmd>lua require('oil').open_float()<CR>";
    }
    {
      mode = "n";
      key = "<C-d>";
      options = {
        silent = true;
        desc = "Center page down";
        noremap = true;
      };
      action = "<C-d>zz";
    }
    {
      mode = "n";
      key = "<C-u>";
      options = {
        silent = true;
        desc = "Center page up";
        noremap = true;
      };
      action = "<C-u>zz";
    }
    {
      mode = "n";
      key = "<Space>m";
      options = {
        silent = true;
        desc = "[Lspsaga] Open workspace diagnostic";
        noremap = true;
      };
      action = "<cmd>Lspsaga show_workspace_diagnostics<CR>";
    }
    {
      mode = "n";
      key = "<Space>o";
      options = {
        silent = true;
        desc = "[RustLsp] Open web doc in browser";
        noremap = true;
      };
      action = "<cmd>RustLsp externalDocs<CR>";
    }
    {
      mode = "n";
      key = "<Space>n";
      options = {
        silent = true;
        desc = "[Lspsaga] Next diagnostic";
        noremap = true;
      };
      action = "<cmd>Lspsaga diagnostic_jump_next<CR>";
    }
    {
      mode = "n";
      key = "<Space>p";
      options = {
        silent = true;
        desc = "[Lspsaga] Prev diagnostic";
        noremap = true;
      };
      action = "<cmd>Lspsaga diagnostic_jump_prev<CR>";
    }
    {
      mode = "n";
      key = "<Space>a";
      options = {
        silent = true;
        desc = "[Lspsaga] Code action";
        noremap = true;
      };
      action = "<cmd>Lspsaga code_action<CR>";
    }
    {
      mode = "n";
      key = "<C-t>";
      options = {
        silent = true;
        desc = "[Lspsaga] Toggle terminal";
        noremap = true;
      };
      action = "<cmd>Lspsaga term_toggle<CR>";
    }
    {
      mode = "t";
      key = "<C-t>";
      options = {
        silent = true;
        desc = "[Lspsaga] Toggle terminal";
        noremap = true;
      };
      action = "<cmd>Lspsaga term_toggle<CR>";
    }
    {
      mode = "n";
      key = "<Space>r";
      options = {
        silent = true;
        desc = "[Lspsaga] Rename";
        noremap = true;
      };
      action = "<cmd>Lspsaga rename<CR>";
    }
    {
      mode = "n";
      key = "<C-]>";
      options = {
        silent = true;
        desc = "[Lspsaga] Go to definition";
        noremap = true;
      };
      action = "<cmd>Lspsaga goto_definition<CR>";
    }
    {
      mode = "n";
      key = "K";
      options = {
        silent = true;
        desc = "[Lspsaga] Hover";
        noremap = true;
      };
      action = "<cmd>Lspsaga hover_doc<CR>";
    }
    {
      mode = "n";
      key = "<Space>f";
      options = {
        silent = true;
        desc = "[LSP] Format";
        noremap = true;
      };
      action = "<cmd>lua require('conform').format()<CR>";
    }
    {
      mode = "n";
      key = "<Space>dc";
      options = {
        silent = true;
        desc = "[DAP] Continue";
        noremap = true;
      };
      action = "<cmd>DapContinue<CR>";
    }
    {
      mode = "n";
      key = "<Space>db";
      options = {
        silent = true;
        desc = "[DAP] Toggle breakpoint";
        noremap = true;
      };
      action = "<cmd>DapToggleBreakpoint<CR>";
    }
    {
      mode = "n";
      key = "<Space>dB";
      options = {
        silent = true;
        desc = "[DAP] Toggle conditional breakpoint";
        noremap = true;
      };
      action = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Condition: '))<CR>";
    }
    {
      mode = "n";
      key = "<Tab>";
      options = {
        silent = true;
        desc = "[Bar] Buffer Next";
        noremap = true;
      };
      action = "<cmd>BufferNext<CR>";
    }
    {
      mode = "n";
      key = "<S-Tab>";
      options = {
        silent = true;
        desc = "[Bar] Buffer Prev";
        noremap = true;
      };
      action = "<cmd>BufferPrevious<CR>";
    }
    {
      mode = "n";
      key = "<Space>c";
      options = {
        silent = true;
        desc = "[Bar] Buffer Close";
        noremap = true;
      };
      action = "<cmd>BufferClose<CR>";
    }
    {
      mode = "n";
      key = "<Space>b";
      options = {
        silent = true;
        desc = "[Bar] Buffer Pick";
        noremap = true;
      };
      action = "<cmd>BufferPick<CR>";
    }
    {
      mode = "n";
      key = "<Space>B";
      options = {
        silent = true;
        desc = "[Bar] Buffer Pick Delete";
        noremap = true;
      };
      action = "<cmd>BufferPickDelete<CR>";
    }
    {
      mode = "n";
      key = "<Space>bb";
      options = {
        silent = true;
        desc = "[Bar] Buffer Close All But Current";
        noremap = true;
      };
      action = "<cmd>BufferCloseAllButCurrent<CR>";
    }
    {
      mode = "n";
      key = "<space>1";
      options = {
        silent = true;
        desc = "[Bar] Buffer Goto 1";
        noremap = true;
      };
      action = "<cmd>BufferGoto 1<CR>";
    }
    {
      mode = "n";
      key = "<space>2";
      options = {
        silent = true;
        desc = "[Bar] Buffer Goto 2";
        noremap = true;
      };
      action = "<cmd>BufferGoto 2<CR>";
    }
    {
      mode = "n";
      key = "<space>3";
      options = {
        silent = true;
        desc = "[Bar] Buffer Goto 3";
        noremap = true;
      };
      action = "<cmd>BufferGoto 3<CR>";
    }
    {
      mode = "n";
      key = "<space>4";
      options = {
        silent = true;
        desc = "[Bar] Buffer Goto 4";
        noremap = true;
      };
      action = "<cmd>BufferGoto 4<CR>";
    }
    {
      mode = "n";
      key = "<space>5";
      options = {
        silent = true;
        desc = "[Bar] Buffer Goto 5";
        noremap = true;
      };
      action = "<cmd>BufferGoto 5<CR>";
    }
    {
      mode = "n";
      key = "<space>6";
      options = {
        silent = true;
        desc = "[Bar] Buffer Goto 6";
        noremap = true;
      };
      action = "<cmd>BufferGoto 6<CR>";
    }
    {
      mode = "n";
      key = "s";
      options = {
        silent = true;
        noremap = false;
        desc = "Leap";
      };
      action = "<Plug>(leap)";
    }
  ];
}
