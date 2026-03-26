{
  description = "MorpheOS - NixOS/darwin configuration";

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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixfmt = {
      url = "github:NixOS/nixfmt";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-apple-silicon,
      stylix,
      nix-darwin,
      nixvim,
      nixfmt,
      ...
    }@inputs:
    let
      username = (import ./config.nix).username;
      lib = import ./lib/morphe.nix {
        inherit inputs username;
        lib = nixpkgs.lib;
      };
      forEachSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in
    {
      formatter = forEachSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.writeShellApplication {
          name = "nixfmt";
          runtimeInputs = [
            pkgs.nixfmt-rfc-style
            pkgs.fd
          ];
          text = ''
            fd -t f -e nix -x nixfmt '{}'
          '';
        }
      );

      darwinConfigurations = {
        "${username}" = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          modules = [
            stylix.darwinModules.stylix
            ./hosts/darwin.nix
            home-manager.darwinModules.home-manager
            (lib.mkHomeManagerDarwinModule ./home-manager/home-mac.nix)
          ];
        };
      };

      nixosConfigurations = {
        mac = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            lib = nixpkgs.lib;
          };
          modules = [
            ./hosts/mac.nix
            nixos-apple-silicon.nixosModules.default
            home-manager.nixosModules.home-manager
            (lib.mkHomeManagerModule ./home-manager/home.nix)
          ];
        };

        pc = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            lib = nixpkgs.lib;
          };
          modules = [
            ./hosts/pc.nix
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            (lib.mkHomeManagerModule ./home-manager/home.nix)
          ];
        };

        wsl = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            lib = nixpkgs.lib;
          };
          modules = [
            ./hosts/wsl.nix
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            (lib.mkHomeManagerModule ./home-manager/home-wsl.nix)
          ];
        };
      };
    };
}
