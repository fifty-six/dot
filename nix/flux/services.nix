{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.syncthing =
    let
      mkDevice =
        {
          name,
          id,
        }:
        {
          ${name} = {
            inherit id;
            addresses = [
              "tcp://${name}"
              "dynamic"
            ];
          };
        };

      devices = [
        {
          name = "ponos";
          id = "IJYDT5J-65BVWJK-DYJSBBU-MSBTARX-BLP5WLC-2U2EN23-3YFRNHL-IVJ7WAD";
        }
        {
          name = "vessel";
          id = "OVRWTSF-V4ZZIFE-IISOWJF-KBVV22J-2IT5B47-HXFXHEX-PU7YOLU-W72TJQK";
        }
        {
          name = "framework";
          id = "WNI2AOE-FAQYTXS-TCGFOMY-MUSC6TY-2Z6JPY3-UXWQSFB-RQZL32U-VUJHQQS";
        }
        {
          name = "bupropion";
          id = "JPIOOUD-SP2JCJ4-FR5MEHE-VNTMU27-WYWVQNR-7EVRJ2S-6MSUIVN-LRMUJQ2";
        }
      ];

      allNames = map ({ name, ... }: name) devices;
    in
    {
      enable = true;
      user = "toor";

      dataDir = "/home/toor";

      settings.devices = lib.mkMerge (map mkDevice devices);

      settings.folders = {
        "~/sync" = {
          id = "fb4vv-9ahvz";
          devices = allNames;
        };
        "~/src/wiki" = {
          id = "obsidian";
          devices = [
            "bupropion"
            "framework"
            "vessel"
          ];
        };
        "~/wsync" = {
          id = "ksp4f-p2odo";
          devices = allNames;
        };
      };
    };

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
    settings.shared_preload_libraries = [
      "vchord.so"
      "vectors.so"
    ];
    extensions = with pkgs; [
      postgresql16Packages.vectorchord
      postgresql16Packages.pgvecto-rs
      postgresql16Packages.pgvector
    ];
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };

  age.secrets.frpc = {
    file = ../secrets/frpc.age;
  };

  systemd.services.frp-client.serviceConfig = {
    LoadCredential = [
      "token:${config.age.secrets.frpc.path}"
    ];

    Environment = [
      "FRPC_TOKEN_FILE=%d/token"
    ];
  };

  services.frp.instances."client" = {
    enable = true;
    role = "client";
    settings = {
      serverAddr = "5.161.56.164";
      serverPort = 7000;

      loginFailExit = false;

      auth.method = "token";
      auth.tokenSource.type = "file";
      auth.tokenSource.file.path = "{{ .Envs.FRPC_TOKEN_FILE }}";

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
        {
          name = "forgejo-ssh";
          type = "tcp";
          localIP = "localhost";
          localPort = 2222;
          remotePort = 22;
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

  services.forgejo = {
    enable = true;
    settings = {
      server = {
        DOMAIN = "forge.fiftysix.dev";
        ROOT_URL = "https://forge.fiftysix.dev";
        HTTP_PORT = 3001;
        SSH_PORT = 2222;
        START_SSH_SERVER = true;
        SSH_SERVER_USE_PROXY_PROTOCOL = true;
      };

      service.DISABLE_REGISTRATION = true;
    };
  };

  services.uptime-kuma = {
    enable = true;

    settings = {
      PORT = "3005";
    };
  };

  services.karakeep = {
    enable = true;
    # idt i need this
    browser.enable = false;
  };

  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.immich = {
    enable = true;
    secretsFile = "/var/lib/immich.d/.env";
    accelerationDevices = null;

    host = "0.0.0.0";

    openFirewall = true;
  };

  services.immich-public-proxy = {
    enable = true;

    port = 3007;
    openFirewall = true;

    immichUrl = "https://immich.in.fiftysix.dev";
    settings = {
      # Allow downloading all if the immich share allows it
      ipp.allowDownloadAll = 1;
    };
  };

  services.ntfy-sh = {
    enable = true;
    settings.base-url = "https://ntfy.in.fiftysix.dev";
  };
}
