{ config, lib, pkgs, ... }:
{
  services.zwave-js-ui = {
    enable = true;
    serialPort = "/dev/serial/by-id/usb-Zooz_800_Z-Wave_Stick_533D004242-if00";
    settings = {
      "HOST" = "::";
      "PORT" = "8091";
    };
  };

  # this is broken and idk why??
  # services.zigbee2mqtt = {
  #   enable = true;
  #   dataDir = "/var/lib/zigbee2mqtt";

  #   settings = {
  #     homeassistant.enabled = true; # config.services.home-assistant.enable;
  #     # permit_join = true;
  #     serial = {
  #       # https://github.com/Koenkk/zigbee2mqtt/discussions/24364
  #       adapter = "zstack";
  #       port = "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0";
  #     };

  #     frontend = {
  #       enabled = true;
  #       port = 8080;
  #     };
  #   };
  # };

  services.postgresql = {
    settings.shared_preload_libraries = [ "vchord.so" "vectors.so" ];
    extensions = with pkgs; [ postgresql16Packages.vectorchord postgresql16Packages.pgvecto-rs postgresql16Packages.pgvector ];
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = ["pattern readwrite #"];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };


  services.frp = {
    enable = true;
    role = "client";
    settings = {
      serverAddr = "5.161.56.164";
      serverPort = 7000;

      loginFailExit = false;

      auth.method = "token";
      auth.token = "redacted";

      proxies = [
        {
          name = "http";
          type = "tcp";
          localIP = "localhost";
          localPort = 80;
          remotePort = 80;
          transport.proxyProtocolVersion = "v2";
        }
        {
          name = "https";
          type = "tcp";
          localIP = "localhost";
          localPort = 443;
          remotePort = 443;
          transport.proxyProtocolVersion = "v2";
        }
      ];
    };
  };

  services.esphome = {
    enable = true;
    openFirewall = true;
  };

  services.miniflux = {
    enable = true;
    config = {
      CREATE_ADMIN = false;
      LISTEN_ADDR = "localhost:3131";
    };
  };

  services.gonic = {
    enable = true;
    settings = {
      music-path = "/srv/gonic/music";
      playlists-path = "/srv/gonic/playlists";
      podcast-path = "/srv/gonic/podcasts/";
    };
  };

  # gotta figure out secrets, see izzy's config?
  # services.forgejo = {
  #   enable = true;
  #   settings = {
  #     server = {
  #       DOMAIN = "forge.fiftysix.dev";
  #       ROOT_URL = "https://forge.fiftysix.dev";
  #       HTTP_PORT = 3001;
  #       SSH_PORT = 2222;
  #     };
  #   };
  # };

  services.uptime-kuma = {
    enable = true;

    settings = {
      PORT = "3003";
    };
  };

  services.karakeep = {
    enable = true;
    # idt i need this
    browser.enable = false;
  };

  # todo: this doesn't like our olm.
  # systemd.services.notify-matrix = {
  #   Unit = {
  #     Description = "Matrix reaction notifier";
  #   };
  #   Install = {
  #     WantedBy = [ "multi-user.target" ];
  #   };
  #   Service = {
  #     ExecStart = "${pkgs.uv} run /srv/notify-matrix";
  #   };
  # };

  services.immich = {
    enable = true;
    secretsFile = "/var/lib/immich.d/.env";
    accelerationDevices =  null;

    host = "0.0.0.0";

    openFirewall = true;
  };

  services.pocket-id = {
    enable = true;

    settings.TRUST_PROXY = true;
    settings.APP_URL = "https://pid.fiftysix.dev";
  };

  services.ntfy-sh = {
    enable = true;
    settings.base-url = "https://ntfy.in.fiftysix.dev";
  };
}
