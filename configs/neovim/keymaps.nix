let
  mk = mode: key: action: desc: {
    inherit mode key action;
    options = {
      silent = true;
      noremap = true;
      desc = desc;
    };
  };
  n = mk "n";
  bufferGotos = builtins.genList (
    i:
    n "<space>${toString (i + 1)}" "<cmd>BufferGoto ${toString (i + 1)}<CR>"
      "[Bar] Buffer Goto ${toString (i + 1)}"
  ) 6;
in
{
  keymaps =
    bufferGotos
    ++ [
      (n "<Space>w" "<cmd>wa<CR>" "Write all")
      (n "<C-q>" "<cmd>wq<CR>" "Write all and quit")
      (n "<Space>q" "<cmd>wq<CR>" "Write all and quit")
      (n "<space>[" "<cmd>Telescope find_files<CR>" "[Telescope] find files")
      (n "<space>]" "<cmd>Telescope keymaps<CR>" "[Telescope] keymaps")
      (n "<space>'" "<cmd>Telescope live_grep<CR>" "[Telescope] live grep")
      (n "<space>;" "<cmd>Telescope buffers<CR>" "[Telescope] buffers")
      (n "<space>." "<cmd>Telescope git_files<CR>" "[Telescope] git files")
      (n "N" "<cmd>lua require('oil').open_float()<CR>" "[Oil] open float")
      (n "<C-d>" "<C-d>zz" "Center page down")
      (n "<C-u>" "<C-u>zz" "Center page up")
      (n "<Space>m" "<cmd>Lspsaga show_workspace_diagnostics<CR>" "[Lspsaga] Open workspace diagnostic")
      (n "<Space>o" "<cmd>RustLsp externalDocs<CR>" "[RustLsp] Open web doc in browser")
      (n "<Space>n" "<cmd>Lspsaga diagnostic_jump_next<CR>" "[Lspsaga] Next diagnostic")
      (n "<Space>p" "<cmd>Lspsaga diagnostic_jump_prev<CR>" "[Lspsaga] Prev diagnostic")
      (n "<Space>a" "<cmd>Lspsaga code_action<CR>" "[Lspsaga] Code action")
      (n "<C-t>" "<cmd>Lspsaga term_toggle<CR>" "[Lspsaga] Toggle terminal")
      (mk "t" "<C-t>" "<cmd>Lspsaga term_toggle<CR>" "[Lspsaga] Toggle terminal")
      (n "<Space>t" "<cmd>Lspsaga finder<CR>" "[Lspsaga] Finder")
      (n "<C-]>" "<cmd>Lspsaga goto_definition<CR>" "[Lspsaga] Go to definition")
      (n "K" "<cmd>Lspsaga hover_doc<CR>" "[Lspsaga] Hover")
      (n "<Space>f" "<cmd>lua require('conform').format()<CR>" "[LSP] Format")
      (n "<Space>dc" "<cmd>DapContinue<CR>" "[DAP] Continue")
      (n "<Space>db" "<cmd>DapToggleBreakpoint<CR>" "[DAP] Toggle breakpoint")
      (n "<Space>dB" "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Condition: '))<CR>" "[DAP] Toggle conditional breakpoint")
      (n "<Tab>" "<cmd>BufferNext<CR>" "[Bar] Buffer Next")
      (n "<S-Tab>" "<cmd>BufferPrevious<CR>" "[Bar] Buffer Prev")
      (n "<Space>c" "<cmd>BufferClose<CR>" "[Bar] Buffer Close")
      (n "<Space>b" "<cmd>BufferPick<CR>" "[Bar] Buffer Pick")
      (n "<Space>B" "<cmd>BufferPickDelete<CR>" "[Bar] Buffer Pick Delete")
      (n "<Space>bb" "<cmd>BufferCloseAllButCurrent<CR>" "[Bar] Buffer Close All But Current")
      {
        mode = [
          "n"
          "v"
        ];
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
