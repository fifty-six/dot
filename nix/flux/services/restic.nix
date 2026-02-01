{
  config,
  lib,
  pkgs,
  ...
}:
{
  age.secrets.restic = {
    file = ../../secrets/restic.age;
  };

  age.secrets.restic-remote-env = {
    file = ../../secrets/restic_remote_auth.age;
  };

  age.secrets.restic-remote-pw = {
    file = ../../secrets/restic_remote.age;
  };

  services.restic = {
    backups =
      let
        repos = {
          local = {
            passwordFile = config.age.secrets.restic.path;
            repository = "/bak";
          };
          remote = {
            passwordFile = config.age.secrets.restic-remote-pw.path;
            environmentFile = config.age.secrets.restic-remote-env.path;
          };
        };
        backups = {
          pg = {
            initialize = true;

            command = [
              "${lib.getExe pkgs.sudo}"
              "-u postgres"
              "${pkgs.postgresql}/bin/pg_dumpall"
            ];

            pruneOpts = [
              "--keep-daily 14"
              "--keep-weekly 4"
              "--keep-monthly 2"
              "--group-by tags"
            ];
          };
          files = {
            initialize = true;

            exclude = [
              "/home/*/.cache"
            ];

            timerConfig = {
              # `systemd-analyze calendar` to check timestamps
              OnCalendar = "00:30";
            };

            # maybe just /var/lib as a whole?
            paths = [
              "/var/lib/immich"
              "/var/lib/gonic"
              "/var/lib/karakeep"
              "/var/lib/private/gonic"
              "/var/lib/private/esphome"
              "/var/lib/private/ntfy-sh"
              "/var/lib/private/zwave-js-ui"
              "/var/lib/redis-immich"
              "/srv/conduwuit"
              "/srv/home-assistant"
              "/srv/ha-loc"
              "/srv/SixtyFive"
              "/srv/typst-bot"
              "/srv/gonic"
              "/var/lib/forgejo"
              "/home"
            ];
          };
        };
        concatMapAttrs = lib.flip lib.concatMapAttrs;
      in
      concatMapAttrs repos (
        rName: repo:
        concatMapAttrs backups (
          bName: backup: {
            "${rName}-${bName}" = repo // backup;
          }
        )
      );
  };
}
