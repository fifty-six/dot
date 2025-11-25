{ pkgs, self, ... }:
{
  nix.settings.experimental-features = "nix-command flakes";

  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility. please read the changelog
  # before changing: `darwin-rebuild changelog`.
  system.stateVersion = 6;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  system.defaults.WindowManager.StandardHideDesktopIcons = true;

  # Key-repeat instead of accents
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;

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
    onActivation.cleanup = "zap";

    taps = [
      "nikitabobko/tap"
    ];
    brews = [
      "helix"
      "mas"
      "uv"
      "ruff"
      "aria2"
      "ddrescue"
      "age"
      "gpg"
      "nmap"
    ];
    casks = [
      "slack"
      "kitty"
      "x2goclient"
      "xquartz"
      "inkscape"
      # kde connect
      "soduto"
      # java
      "temurin"
      "android-platform-tools"
      "neovide-app"
      "tailscale-app"
      "syncthing-app"
      "submariner"
      "nikitabobko/tap/aerospace"
      "orcaslicer@nightly"
      "shadowsocksx-ng"
      "gimp"
      "krita"
      "gdisk"
    ];
    masApps = {
      "Wireguard" = 1451685025;
    };
  };
}
