{ config, pkgs, lib, ... }:

{ 
    imports = [ ../common.nix ];

    home.username = "home";
    home.homeDirectory = "/home/home";
}
