{
  pkgs,
  ...
}:
let
  leaderf = pkgs.vimUtils.buildVimPlugin {
    name = "leaderf";
    src = pkgs.fetchFromGitHub {
      owner = "Yggdroot";
      repo = "LeaderF";
      rev = "17cb04b2fbb817e899ba057c0f3d794134a0c35d";
      sha256 = "sha256-paDF3MkoZBcRBSME6uSv5XMBGk1knNn/hUN5TaXrCvo=";
    };
  };
in
{
  programs.vim = {
    enable = true;
    extraConfig = ''
      colorscheme elflord
      set noswapfile
      set number
      set relativenumber
      set completeopt=menu,menuone,preview,noselect,noinsert
      let g:ale_fix_on_save = 1
      let g:ale_completion_enabled = 1
      let g:ale_sign_error = "✗"
      let g:ale_sign_warning = "⚠"
      let g:ale_linters = { 'rust': ['analyzer'] }
      let g:ale_fixers = { 'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'] }
      let g:ale_disable_lsp = 0
      let g:ale_set_quickfix = 1

      " Leaderf
      let g:Lf_WindowPosition = 'popup'

      nmap K :ALEHover<CR>
      nmap gd :ALEGoToDefinition<CR>
      nmap <Space>w :w<CR>
      nmap <C-Q> :wq!<CR>
      nmap <Space>n :cn<CR>
      nmap <Space>p :cN<CR>
      nmap <Space>a :ALECodeAction<CR>
      nmap <C-]> :ALEGoToDefinition<CR>
      nmap <Space>[ :LeaderfFile<CR>
      nmap <Space>' :LeaderfRgInteractive<CR>
      nmap <Space><Space> :LeaderfQuickFix<CR>
      nmap <Space>l :LeaderfQuickFix<CR>
      imap <silent><script><expr> <C-]> copilot#Accept("\<CR>") 
      let g:copilot_no_tab_map = v:true

      let g:ale_rust_analyzer_config = {
      \  'check': {
      \    'command': 'clippy',
      \    'features': 'all'
      \  }
      \}

      " Netrw
      let g:netrw_winsize = 30
      let g:netrw_keepdir = 0
      nnoremap N :Lexplore %:p:h<CR>
      function! NetrwMapping()
        nmap <buffer> N :Lexplore<CR>
        nmap <buffer> ff %:w<CR>:buffer #<CR>
      endfunction

      augroup netrw_mapping
        autocmd!
          autocmd filetype netrw call NetrwMapping()
      augroup END
    '';
    plugins = with pkgs.vimPlugins; [
      vim-sensible
      rust-vim
      ale
      copilot-vim
      leaderf
      auto-pairs
      vim-surround
      vinegar
    ];
  };
}
