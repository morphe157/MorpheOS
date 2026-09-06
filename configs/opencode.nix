{ ... }:
{
  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    plugin = [
      "compound-engineering@git+https://github.com/EveryInc/compound-engineering-plugin.git"
    ];
  };
}
