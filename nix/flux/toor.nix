{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../common.nix
    ../linux.nix
  ];

  home.packages = [
    pkgs.arion
    pkgs.neovim
  ];

  home.username = "toor";
  home.homeDirectory = "/home/toor";
}
