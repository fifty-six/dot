{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.blocky = {
    enable = true;
    settings = {
      upstreams.groups.default = [
        "9.9.9.9"
        "1.1.1.1"
      ];

      customDNS = {
        customTTL = "300s";
        filterUnmappedTypes = true;
        mapping = {
          "in.fiftysix.dev" = "100.75.192.17";
        };
      };

      # Make tailscale hosts resolve properly using this DNS,
      # which is important because otherwise it says NXDOMAIN
      # and caddy is sad.
      conditional = {
        mapping = {
          "wind-everest.ts.net" = "100.100.100.100";
        };
      };

      bootstrapDns = "9.9.9.9";

      blocking = {
        denylists = {
          ads = [ "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" ];
        };
        clientGroupsBlock = {
          default = [ "ads" ];
        };
      };

      ports = {
        dns = 53;
        http = 4000;
      };

      log = {
        level = "info";
        format = "json";
      };

      prometheus = {
        enable = true;
        path = "/metrics";
      };
    };
  };
}
