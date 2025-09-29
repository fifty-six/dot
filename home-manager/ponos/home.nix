{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../common.nix
  ];

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
    pkgs.p7zip
    pkgs.distant
  ];

  programs.kitty.settings.macos_option_as_alt = "both";

  programs.zsh = {
    enable = true;

    shellAliases = {
      switch = "sudo darwin-rebuild switch --flake ~/dot/home-manager/ponos -v |& nom";
    };
  };

  programs.git.userEmail = lib.mkForce "yusuf.bham@zetier.com";
}
