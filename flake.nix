#{  outputs = { self, nixpkgs }: {    nixosConfigurations.hyperboid-laptop = nixpkgs.lib.nixosSystem {      system = "x86_64-linux";      modules = [ ./configuration.nix ];    };  };}
{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-2411.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wine.url = "github:nixos/nixpkgs/2c8d3f48d33929642c1c12cd243df4cc7d2ce434";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-wine,
    nixpkgs-2411,
    home-manager,
    ...
  }: let
      # System types to support.
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forSystems = systems: (innerSetFunc: (nixpkgs.lib.genAttrs systems (system: innerSetFunc 
        {
          system = system;
          pkgs = import nixpkgs {system = system;};
          pkgs-unstable = import nixpkgs-unstable {system = system;};}
      )));
      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = forSystems supportedSystems;
  in rec {
    specialArgs = {
      inputs = inputs;
      unstable = import nixpkgs-unstable {
        config.allowUnfree = true;
        system = "x86_64-linux";
      };
      pkgs-wine = import nixpkgs-wine {
        config.allowUnfree = true;
        system = "x86_64-linux";
      };
      mypkgs = packages.x86_64-linux;
      pkgs2411 = nixpkgs-2411.legacyPackages.x86_64-linux;
    };
    nixosConfigurations = {
      hyperboid-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./laptop/hardware-configuration.nix
          ./laptop/configuration.nix
          ./laptop/gpucompute.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hyperboid = import ./laptop/homes/hyperboid.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
        inherit specialArgs;
      };
      hyperboid-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hyperboid = import ./laptop/homes/hyperboid.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            networking.hostName = specialArgs.unstable.lib.mkForce "hyperboid-desktop";
          }
        ];
        inherit specialArgs;
      };
      lizzie-desktop = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./desktop2/configuration.nix
          ./common.nix
        ];
        inherit specialArgs;
      };
      hyperboid-schmesktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./schmesktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hyperboid = import ./laptop/homes/hyperboid.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            networking.hostName = specialArgs.unstable.lib.mkForce "hyperboid-schmesktop";
          }
        ];
        inherit specialArgs;
      };
      nullanoid-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nullanoid/configuration.nix
        ];
        inherit specialArgs;
      };
    };
    packages = forAllSystems ({system, pkgs, pkgs-unstable}: {
      tiled = pkgs-unstable.libsForQt5.callPackage ./packages/tiled-master.nix {};
    }) // (forSystems (supportedSystems ++ ["aarch64-darwin" "x86_64-darwin"]) ({system, pkgs, pkgs-unstable}: {
      love = pkgs.callPackage ./packages/love.nix {inherit system;};
    }));
  };
}
