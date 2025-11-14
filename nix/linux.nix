{
  options,
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
  options = {
    graphical.enable = lib.mkEnableOption "Enable graphical user services.";
    bar.enable = lib.mkEnableOption "Enable quickshell bar auto-start.";
  };

  config = {
    programs = lib.mkIf config.graphical.enable {
      vicinae = {
        enable = true;
        systemd.enable = true;
      };
    };

    xdg.userDirs = {
      enable = true;
      publicShare = "$HOME/media/public";
      desktop = "$HOME/media/desktop";
      music = "$HOME/media/music";
      pictures = "$HOME/media/pictures";
      videos = "$HOME/media/videos";
      templates = "$HOME/media/templates";
    };

    services.clipse.enable = config.graphical.enable;

    services.swaync = {
      enable = config.graphical.enable;
      settings = swaynccfg;
      style = mklink ../swaync.css;
    };

    systemd.user.services.quickshell = lib.mkIf config.graphical.enable {
      Unit = {
        Description = "Quickshell";
        After = [ "graphical-session.target" ];
      };
      Install = {
        WantedBy = lib.mkIf config.bar.enable [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "/usr/bin/qs";
        Environment = "QT_QPA_PLATFORMTHEME=gtk3";
      };
    };

    systemd.user.services.ntfy = lib.mkIf config.graphical.enable {
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

    systemd.user.services.easyeffects = lib.mkIf config.graphical.enable {
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

    systemd.user.services.kdeconnectd = lib.mkIf config.graphical.enable {
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
  };
}
