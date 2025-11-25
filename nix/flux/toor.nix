{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../common.nix
    ../linux.nix
  ];

  home.packages = [
    pkgs.tree
  ];

  home.username = "toor";
  home.homeDirectory = "/home/toor";
}
