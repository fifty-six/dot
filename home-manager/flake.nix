{
  description = "home-manager/nix-darwin config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
  }: let
    linux = nixpkgs.legacyPackages."x86_64-linux";
  in {
    homeConfigurations."home@framework" = home-manager.lib.homeManagerConfiguration {
      pkgs = linux;

      modules = [./framework/home.nix];
    };

    homeConfigurations."toor@flux" = home-manager.lib.homeManagerConfiguration {
      pkgs = linux;

      modules = [./flux/toor.nix];
    };

    homeConfigurations."home@vessel" = home-manager.lib.homeManagerConfiguration {
      pkgs = linux;

      modules = [./vessel/home.nix];
    };

    homeConfigurations."yusuf.bham@zetier.com" = home-manager.lib.homeManagerConfiguration {
      pkgs = linux;

      modules = [./work/work.nix];
    };

    darwinConfigurations."ponos" = nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs;
        inherit self;
      };
      modules = [
        ./ponos/darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users.home = ./ponos/home.nix;
        }
      ];
    };
  };
}
