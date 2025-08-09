{ config, pkgs, lib, ... }:

{ 
    imports = [ ../common.nix ];

    home.username = "toor";
    home.homeDirectory = "/home/toor";
}
