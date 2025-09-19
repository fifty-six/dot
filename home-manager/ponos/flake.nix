{
  description = "darwin work config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
  }: let
    configuration = {pkgs, ...}: {
      nix.settings.experimental-features = "nix-command flakes";

      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility. please read the changelog
      # before changing: `darwin-rebuild changelog`.
      system.stateVersion = 6;

      system.keyboard.enableKeyMapping = true;
      system.keyboard.remapCapsLockToControl = true;

      system.defaults.WindowManager.StandardHideDesktopIcons = true;
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Declare the user that will be running `nix-darwin`.
      users.users.home = {
        name = "home";
        home = "/Users/home";
      };

      security.pam.services.sudo_local.touchIdAuth = true;

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;

      environment.systemPackages = [
        pkgs.neofetch
        pkgs.neovim
      ];

      system.primaryUser = "home";
      homebrew = {
        enable = true;
        # onActivation.cleanup = "uninstall";

        taps = [];
        casks = [
          "slack"
          "kitty"
          "x2goclient"
          "xquartz"
        ];
      };
    };
  in {
    darwinConfigurations."ponos" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs;};
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users.home = ./home.nix;
        }
      ];
    };
  };
}
