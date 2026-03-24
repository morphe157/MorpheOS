{ lib, ... }:

{
  options.morphe.hyprlandMonitors = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "Hyprland monitor configuration string";
  };
}
