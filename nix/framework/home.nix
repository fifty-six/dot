{
  config,
  pkgs,
  lib,
  ...
}:
let
  util = import ./../util.nix { inherit pkgs; };
in
{
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

          # man what the fuck
          # https://www.reddit.com/r/linux_gaming/comments/1kk3ddo/simple_guide_fix_audio_crackling_or_sudden/
          settings.clock.force-rate = 48000;
          settings.clock.force-quantum = 500;
        };
      };
      "pipewire-pulse.conf.d"."pipewire-pulse.conf".source = util.toJSON {
        pulse.properties = {
          # Framework speaker has popping without this.
          # Thank you to this reddit post for the solution (?)
          # I had to add the stuff for pipewire.conf as well so not sure anymore lowkey
          # https://www.reddit.com/r/archlinux/comments/1kcns3u/pipewire_ungodly_crackling/mq4u6gs/
          pulse.min.quantum = "512/48000";
        };
      };
    };
  };
}
