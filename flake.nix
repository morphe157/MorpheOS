{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager.url = "github:nix-community/home-manager/";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-apple-silicon,
      stylix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      homeConfigurations = {
        "mburdyna@mac" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs outputs;};
          # > Our main home-manager configuration file <
          modules = [
            ./home-manager/home-mac.nix
          ];
        };
      };

      nixosConfigurations = {
        mac = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            username = "morphe";
          };
          # > Our main nixos configuration file <
          modules = [
            stylix.nixosModules.stylix
            ./hosts/mac.nix
            nixos-apple-silicon.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.users.morphe = import home-manager/home.nix;
            }
          ];
        };
        pc = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            username = "morphe";
          };
          # > Our main nixos configuration file <
          modules = [
            stylix.nixosModules.stylix
            ./hosts/pc.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.users.morphe = import home-manager/home.nix;
            }
          ];
        };
      };
    };
}
