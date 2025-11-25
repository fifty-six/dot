{ pkgs, lib, config, ... }:

{
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
  };

  # Enable container name DNS for all Podman networks.
  networking.firewall.interfaces = let
    matchAll = if !config.networking.nftables.enable then "podman+" else "podman*";
  in {
    "${matchAll}".allowedUDPPorts = [ 53 ];
  };

  virtualisation.oci-containers.backend = "podman";

  # Containers
  virtualisation.oci-containers.containers."ha" = {
    autoStart = true;

    image = "ghcr.io/home-assistant/home-assistant:stable";
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/run/dbus:/run/dbus:ro"
      "/srv/home-assistant/config:/config:rw"
    ];

    log-driver = "journald";

    # TODO: does this need privs? probably?
    extraOptions = [
      "--network=host"
      "--privileged"
    ];
  };
}
