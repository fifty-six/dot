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
    homeconfig = {pkgs, ...}: {
      home.username = "home";
      home.homeDirectory = "/Users/home";
      # Let home-manager install and manage itself.
      programs.home-manager.enable = true;

      home.packages = [
        pkgs.fzf
        pkgs.ripgrep
        pkgs.jujutsu
        pkgs.alejandra
        pkgs.black
        pkgs.isort
        pkgs.rustfmt
        pkgs.bat
      ];

      programs.zsh = {
        enable = true;
        shellAliases = {
            switch = "sudo darwin-rebuild switch --flake ~/dot/home-manager/ponos -v |& nom";
        };
      };

      imports = [
        ../common.nix
      ];

      # home.sessionVariables = {
      #   EDITOR = "vim";
      # };

      # home.file.".vimrc".source = ./vim_configuration;

      # programs.zsh = {
      #   enable = true;
      #   shellAliases = {
      #     switch = "darwin-rebuild switch --flake ~/.config/nix";
      #   };
      # };

      # programs.git = {
      #   enable = true;
      #   userName = "$FIRSTNAME $LASTNAME";
      #   userEmail = "me@example.com";
      #   ignores = [ ".DS_Store" ];
      #   extraConfig = {
      #     init.defaultBranch = "main";
      #     push.autoSetupRemote = true;
      #   };
      # };
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
          home-manager.users.home = homeconfig;
        }
      ];
    };
  };
}
