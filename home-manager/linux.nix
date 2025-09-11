{ config, pkgs, lib, ... }:

let
    mklink = config.lib.file.mkOutOfStoreSymlink;
    inherit (import ./swaync.nix) swaynccfg;
in
{
  xdg.userDirs = {
    enable = true;
    publicShare = "$HOME/media/public";
    desktop = "$HOME/media/desktop";
    music = "$HOME/media/music";
    pictures = "$HOME/media/pictures";
    videos = "$HOME/media/videos";
    templates = "$HOME/media/templates";
  };

  services.clipse.enable = true;

  services.swaync = {
    enable = true;
    settings = swaynccfg;
    style = mklink ../swaync.css;
  };
}
