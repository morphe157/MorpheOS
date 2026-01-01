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
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixos-aarch64-widevine.url = "github:epetousis/nixos-aarch64-widevine";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-apple-silicon,
      stylix,
      nix-darwin,
      lanzaboote,
      # nixos-aarch64-widevine,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      inherit (import ./config.nix) username;
    in
    {
      darwinConfigurations = {
        "${username}" = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          modules = [
            stylix.darwinModules.stylix
            ./hosts/darwin.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                users."${username}" = import home-manager/home-mac.nix;
                backupFileExtension = "backup";
              };
            }
          ];
        };
      };

      nixosConfigurations = {
        mac = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          # > Our main nixos configuration file <
          modules = [
            stylix.nixosModules.stylix
            ./hosts/mac.nix
            nixos-apple-silicon.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              # nixpkgs.overlays = [ nixos-aarch64-widevine.overlays.default ];
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                users."${username}" = import home-manager/home.nix;
              };
            }
          ];
        };
        pc = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          # > Our main nixos configuration file <
          modules = [
            lanzaboote.nixosModules.lanzaboote
            ./hosts/pc.nix
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                users."${username}" = import home-manager/home.nix;
              };
            }
          ];
        };
        wsl = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          # > Our main nixos configuration file <
          modules = [
            ./hosts/wsl.nix
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                users."${username}" = import home-manager/home-wsl.nix;
              };
            }
          ];
        };
      };
    };
}
