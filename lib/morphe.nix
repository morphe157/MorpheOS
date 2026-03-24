{
  lib,
  inputs,
  username,
}:
let
  inherit (inputs) home-manager stylix;
in
{
  mkHomeManagerModule = homeFile: {
    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = true;
      users."${username}" = import homeFile;
      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };

  mkHomeManagerDarwinModule = homeFile: {
    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = true;
      users."${username}" = import homeFile;
      backupFileExtension = "backup";
      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };

  sharedNixosModules = [
    stylix.nixosModules.stylix
    home-manager.nixosModules.home-manager
  ];

  sharedDarwinModules = [
    stylix.darwinModules.stylix
    home-manager.darwinModules.home-manager
  ];
}
