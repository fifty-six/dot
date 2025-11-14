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

  home.username = "home";
  home.homeDirectory = "/home/home";

  graphical.enable = true;
}
