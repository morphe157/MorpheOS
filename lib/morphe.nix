{
  lib,
  inputs,
}:
let
  inherit (inputs) home-manager stylix;
in
{
  mkHomeManagerModule = user: homeFile: {
    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = true;
      users."${user.username}" = import homeFile;
      extraSpecialArgs = {
        inherit inputs user;
      };
    };
  };

  mkHomeManagerDarwinModule = user: homeFile: {
    home-manager = {
      useGlobalPkgs = false;
      useUserPackages = true;
      users."${user.username}" = import homeFile;
      backupFileExtension = "backup";
      extraSpecialArgs = {
        inherit inputs user;
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
