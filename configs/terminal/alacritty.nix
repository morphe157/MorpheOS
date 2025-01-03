{
  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell = "tmux";
      scrolling.history = 10000;
      window = {
        startup_mode = "Maximized";
        decorations = "Buttonless";
      };
      font = {
        size = 23.0;
        normal = {
          family = "CommitMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "CommitMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "CommitMono Nerd Font";
          style = "Italic";
        };
      };
    };
  };
}
