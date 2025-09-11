{ config, pkgs, lib, ... }:

{ 
    imports = [ 
        ../common.nix 
        ../linux.nix
    ];

    home.username = "toor";
    home.homeDirectory = "/home/toor";
}
