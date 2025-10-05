{
  config,
  pkgs,
  lib,
  ...
}: let
  util = import ./../util.nix {inherit pkgs;};
in {
  imports = [
    ../common.nix
    ../linux.nix
  ];

  home.username = "home";
  home.homeDirectory = "/home/home";

  xdg.configFile = util.toFileTree {
    pipewire = {
      "pipewire.conf.d"."pipewire.conf".source = util.toJSON {
        context.properties = {
          # I'm gonna be real I don't remember why I have these
          default.clock.rate = 44100;
          default.clock.quantum = 4096;
          default.clock.min-quantum = 512;
          default.clock.max-quantum = 16384;
        };
      };
      "pipewire-pulse.conf.d"."pipewire-pulse.conf".source = util.toJSON {
        pulse.properties = {
          # Framework speaker has popping without this.
          # Thank you to this reddit post for the solution
          # https://www.reddit.com/r/archlinux/comments/1kcns3u/pipewire_ungodly_crackling/mq4u6gs/
          pulse.min.quantum = "512/48000";
        };
      };
    };
  };
}
