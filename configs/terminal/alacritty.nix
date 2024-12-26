{
  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell.program = "tmux";
      scrolling.history = 10000;
    };
  };
}
