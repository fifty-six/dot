{
  config,
  pkgs,
  lib,
  ...
}:

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

  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell";
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "/usr/bin/qs";
      Environment = "QT_QPA_PLATFORMTHEME=gtk3";
    };
  };

  systemd.user.services.ntfy = {
    Unit = {
      Description = "ntfy";
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.ntfy-sh}/bin/ntfy subscribe --from-config";
    };
  };

  systemd.user.services.easyeffects = {
    Unit = {
      Description = "Easyeffects Daemon";
      Requires = [ "pipewire.service" ];
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "/usr/bin/easyeffects --gapplication-service";
    };
  };

  systemd.user.services.kdeconnectd = {
    Unit = {
      Description = "KDE Connect";
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "/usr/bin/kdeconnectd";
    };
  };

}
