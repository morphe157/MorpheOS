let
  text = ''
    set theme midnight
  '';
in
{
  home.file.".tridactylrc" = {
    enable = true;
    inherit text;
  };
}
