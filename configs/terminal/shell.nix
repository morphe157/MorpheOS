{ pkgs, ... }:
{
  home.packages = with pkgs; [
    grc
    eza
    zoxide
    bat
    ripgrep
    tldr
    fzf
    fd
    btop
  ];
  programs = {
    fish = {
      enable = true;
      plugins = [
        {
          name = "grc";
          inherit (pkgs.fishPlugins.grc) src;
        }
        {
          name = "pure";
          inherit (pkgs.fishPlugins.pure) src;
        }
        {
          name = "fzf-fish";
          inherit (pkgs.fishPlugins.fzf-fish) src;
        }
      ];
      shellAliases = {
        ll = "eza -l";
        lla = "eza -la";
        ns = "nix search nixpkgs";
        gpt = "tgpt -q -w | glow";
        cat = "bat";
      };
      functions.tmux = ''
        if test (count $argv) -eq 0
          command tmux attach 2>/dev/null; or command tmux new-session
        else
          command tmux $argv
        end
      '';
      shellInit = ''
        [ -f "~/init.fish" ] || touch ~/init.fish
        source ~/init.fish
        bind -a ctrl-t _fzf_search_directory
      '';
    };
    eza.enable = true;
    direnv.enable = true;
    zoxide = {
      enable = true;
    };
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        command_timeout = 1300;
        scan_timeout = 50;
        format = "$git_branch$git_status $username$hostname$directory";
        character = {
          success_symbol = "[](bold green) ";
          error_symbol = "[✗](bold red) ";
        };
      };
    };
  };
}
