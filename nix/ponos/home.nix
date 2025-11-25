{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../common.nix
    ../work-common.nix
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
    pkgs.python3
    pkgs.glow
    pkgs.lua-language-server
    pkgs.mosh
    pkgs.imagemagick
    pkgs.ddrescue
    pkgs.hyfetch
  ];

  programs.kitty.settings.macos_option_as_alt = "both";

  programs.zsh = {
    enable = true;

    shellAliases = {
      switch = "sudo darwin-rebuild switch --flake ~/dot -v |& nom";
    };
  };

  programs.git.userEmail = lib.mkForce "yusuf.bham@zetier.com";
}
