{
  description = "Home Manager configuration of home";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."home@framework" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./framework/home.nix ];
      };
      homeConfigurations."toor@flux" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./flux/toor.nix ];
      };
      homeConfigurations."home@vessel" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./vessel/home.nix ];
      };

      homeConfigurations."yusuf.bham@zetier.com" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./work/work.nix ];
      };
    };
}
