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
    nixos-cli.url = "github:nix-community/nixos-cli";
    agenix.url = "github:yaxitech/ragenix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nixos-cli,
      agenix
    }:
    let
      linux = nixpkgs.legacyPackages."x86_64-linux";
    in
    {
      nixosConfigurations.flux = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [
       	 ./nix/flux/configuration.nix
         nixos-cli.nixosModules.nixos-cli
	       home-manager.nixosModules.home-manager
         {
           home-manager.useGlobalPkgs = true;
           home-manager.useUserPackages = true;
           home-manager.users.toor = ./nix/flux/toor.nix;
         }
         agenix.nixosModules.default
       ];
      };

      homeConfigurations."home@framework" = home-manager.lib.homeManagerConfiguration {
        pkgs = linux;

        modules = [ ./nix/framework/home.nix ];
      };

      homeConfigurations."home@vessel" = home-manager.lib.homeManagerConfiguration {
        pkgs = linux;

        modules = [ ./nix/vessel/home.nix ];
      };

      homeConfigurations."yusuf.bham@zetier.com" = home-manager.lib.homeManagerConfiguration {
        pkgs = linux;

        modules = [ ./nix/work/work.nix ];
      };

      darwinConfigurations."ponos" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs;
          inherit self;
        };
        modules = [
          ./nix/ponos/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users.home = ./nix/ponos/home.nix;
          }
        ];
      };
    };
}
