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

  services.restic = {
    backups = let
      passwordFile = config.age.secrets.restic.path;
      repository = "/bak";
    in {
      pg = {
        initialize = true;

        inherit passwordFile;
        inherit repository;

        command = [
          "${lib.getExe pkgs.sudo}"
            "-u postgres"
            "${pkgs.postgresql}/bin/pg_dumpall"
        ];
        extraBackupArgs = [
          "--tag database"
        ];
        pruneOpts = [
          "--keep-daily 14"
            "--keep-weekly 4"
            "--keep-monthly 2"
            "--group-by tags"
        ];
      };

      local = {
        initialize = true;

        inherit passwordFile;
        inherit repository;

        exclude = [
          "/home/*/.cache"
        ];

        # maybe just /var/lib as a whole?
        paths = [
          "/var/lib/immich"
          "/var/lib/gonic"
          "/var/lib/karakeep"
          "/srv/conduwuit"
          "/srv/home-assistant"
          "/srv/ha-loc"
          "/var/lib/forgejo"
          "/home"
        ];
      };

      # TODO: remote s3
    };
  };
}
