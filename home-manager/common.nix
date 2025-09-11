{ config, pkgs, lib, ... }:

let 
    HOME = builtins.getEnv "HOME";
    inherit (import ./colors.nix) colors;
    inherit (import ./swaync.nix) swaynccfg;
    mklink = config.lib.file.mkOutOfStoreSymlink;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # home.username = "home";
    # home.homeDirectory = "/home/home";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.nixd
    pkgs.ntfy-sh
    pkgs.jjui
    pkgs.comma
    pkgs.llvmPackages_20.bintools-unwrapped
    pkgs.nix-output-monitor
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".local/share/zsh/.zimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dot/zimrc";
  };

  xdg.configFile = {
    ".config/latexmk/latexmkrc".text = ''
        $pdflatex = 'pdflatex --shell-escape %O %S';
    '';

    ".config/chromium-flags.conf".text = ''
        --enable-features=VaapiVideoDecoder,VaapiIgnoreDriverChecks
        --enable-gpu-rasterization
        --ignore-gpu-blacklist
        --enable-zero-copy
        --disable-gpu-driver-workarounds
        --ozone-platform-hint=auto
    '';

    "ncdu/config".text = "--color dark";
    "wezterm/config.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dot/wezterm.lua";
    "ntfy/client.yml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dot/ntfy.yml";
    "jj/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dot/jj.toml";
    "niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dot/niri.kdl";
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/home/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
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

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/state/nix/profile/bin"
    "${config.home.homeDirectory}/.local/share/dotnet/.dotnet/tools"

    # all my xdg gone
    # "${config.home.homeDirectory}/.local/pipx/venvs/flit/bin"

    "${config.xdg.dataHome}/npm/bin"

    "${config.home.homeDirectory}/dot/bin"
  ];

  # yes i am cheating
    # home.activation.swaync = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #       if /usr/bin/systemctl --user status swaync > /dev/null; then 
    #           run /usr/bin/systemctl --user enable --now swaync
    #       fi
    # '';

  # TODO: enable only if exists.
  systemd.user.services.ntfy = {
    Unit = {
        Description = "ntfy";

      After = ["graphical-session.target"];
    };
    Install = { 
            WantedBy = ["graphical-session.target"]; 

        };
    Service = {
        ExecStart = "${pkgs.ntfy-sh}/bin/ntfy subscribe --from-config";
    };
  };

  systemd.user.services.easyeffects = {
    Unit = {
      Description = "Easyeffects Daemon";
      Requires = ["pipewire.service"];
      After = ["graphical-session.target"];
    };
    Install = { WantedBy = ["graphical-session.target"]; };
    Service = {
      ExecStart = "/usr/bin/easyeffects --gapplication-service";
    };
  };

  systemd.user.services.kdeconnectd = {
    Unit = {
        Description = "KDE Connect";

      After = ["graphical-session.target"];
    };
    Install = { WantedBy = ["graphical-session.target"]; };
    Service = {
        ExecStart = "/usr/bin/kdeconnectd";
    };
  };

  services.clipse = {
      enable = true;
  };

  services.swaync = {
    enable = true;
    settings = swaynccfg;
    style = mklink ../swaync.css;
  };

  programs.nushell = {
    enable = true;

    configFile.source = ./../nu/config.nu;
    envFile.source = ./../nu/env.nu;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.zoxide = {
      enable = true;

      enableZshIntegration = true;
      enableNushellIntegration = true;
  };

  programs.alacritty = {
    enable = true;

    package = pkgs.emptyDirectory;

    settings = {

        colors = {
            primary = {
                background = colors.background;
                foreground = colors.foreground;
            };
            bright = colors.bright;
            normal = colors.normal;
            dim = colors.dim;
        };
        # colors = {
        #     bright = {
        #         black = "#8b8b8b";
        #         red = "#f46d6d";
        #         green = "#e3ffa2";
        #         yellow = "#feca88";
        #         blue    = "#a1d6ff";
        #         magenta = "#f8b7ec";
        #         cyan = "#c7ffff";
        #         white   = "#373737";
        #     };
        #     dim = {
        #         black = "#141414";
        #         red = "#8b3737";
        #         green = "#7f9253";
        #         yellow = "#d1a76c";
        #         blue = "#5d8799";
        #         magenta = "#8f6585";
        #         cyan = "#689b92";
        #         white = "#b9b9b9";
        #     };
        #     primary.background = "#000000";
        # };

        window = {
            padding = {
                x = 15;
                y = 15;
            };
        };

        keyboard.bindings = [
            {
                key = "Equals";
                mods = "Control";
                action = "IncreaseFontSize";
            }
            {
                key = "Minus";
                mods = "Control";
                action = "DecreaseFontSize";
            }
        ];


        font.size = 12;
        font.normal.family = "Fira Code NerdFont";
    };
  };

  programs.kitty = {
    enable = true;

    package = pkgs.emptyDirectory;

    font = {
        name = "FiraCode Nerd Font Ret";
        size = 12;
    };

    shellIntegration.enableZshIntegration = true;
    shellIntegration.enableBashIntegration = true;

    settings = {
        text_composition_strategy = "legacy";

        window_padding_width = 10;
        background_opacity = "0.7";

        font_features = "FiraCodeNF-Ret +ss08";
        disable_ligatures = "cursor";

        # Colors from shared scheme
        foreground = colors.foreground;
        background = colors.background;
        selection_foreground = colors.selection.foreground;
        selection_background = colors.selection.background;
        url_color = colors.url;
        cursor = colors.cursor.cursor;
        cursor_text_color = colors.cursor.text;
        
        active_tab_foreground = colors.tab.active.foreground;
        active_tab_background = colors.tab.active.background;
        inactive_tab_foreground = colors.tab.inactive.foreground;
        inactive_tab_background = colors.tab.inactive.background;

        # Terminal colors
        color0 = colors.normal.black;
        color1 = colors.normal.red;
        color2 = colors.normal.green;
        color3 = colors.normal.yellow;
        color4 = colors.normal.blue;
        color5 = colors.normal.magenta;
        color6 = colors.normal.cyan;
        color7 = colors.normal.white;

        color8 = colors.bright.black;
        color9 = colors.bright.red;
        color10 = colors.bright.green;
        color11 = colors.bright.yellow;
        color12 = colors.bright.blue;
        color13 = colors.bright.magenta;
        color14 = colors.bright.cyan;
        color15 = colors.bright.white;

        # foreground = "#D1D5DB";

        # # background               #111827
        # background = "#000000";
        # selection_foreground = "#D1D5DB";
        # selection_background = "#374151";

        # url_color = "#957FB8";

        # cursor = "#D1D5DB";
        # cursor_text_color = "#111827";

        # active_tab_foreground = "#D1D5DB";
        # active_tab_background = "#111827";
        # inactive_tab_foreground = "#817c9c";
        # inactive_tab_background = "#232136";

        # # black
        # color0 = "#6B7280";
        # color8 = "#6B7280";

        # # red
        # color1 = "#ff646a";
        # color9 = "#f46d6d";

        # # green
        # color2 = "#c1df7f";
        # color10 = "#e3ffa2";

        # # yellow
        # color3 = "#f4bf75";
        # color11 = "#feca88";

        # # blue
        # color4 = "#8ecee8";
        # color12 = "#a1d6ff";

        # # magenta
        # color5 = "#d999cb";
        # color13 = "#f8b7ec";

        # # cyan
        # color6 = "#9afaf3";
        # color14 = "#c7ffff";

        # # white
        # color7 = "#565656";
        # color15 = "#373737";
    };
  };

  # programs.wezterm = {
  #   enable = true;

  #   enableZshIntegration = true;
  #   enableBashIntegration = true;

  #   extraConfig = ''
  #     -- Load user config
  #     local ok, user_config = pcall(require, 'config')
  #     if not ok then
  #       return {}
  #     end
  #     
  #     -- Return merged config
  #     return user_config

  #     -- local config = {}
  #     -- 
  #     -- if wezterm.config_builder then
  #     --   config = wezterm.config_builder()
  #     -- end
  #     -- 
  #     -- config.color_scheme = 'custom'
  #     -- config.font = wezterm.font('FiraCode Nerd Font Ret')
  #     -- config.font_size = 12
  #     -- config.harfbuzz_features = {'ss08'}
  #     -- -- config.disable_ligatures_in_cursor_row = true
  #     -- 
  #     -- config.window_padding = {
  #     --   left = 10,
  #     --   right = 10,
  #     --   top = 10,
  #     --   bottom = 10,
  #     -- }
  #     -- 
  #     -- config.window_background_opacity = 0.7
  #     -- 
  #     -- return config
  #   '';

  #   colorSchemes = {
  #     "custom" = {
  #       foreground = colors.foreground;
  #       background = colors.background;
  #       selection_fg = colors.selection.foreground;
  #       selection_bg = colors.selection.background;
  #       cursor_fg = colors.cursor.text;
  #       cursor_bg = colors.cursor.cursor;
  #       cursor_border = colors.cursor.cursor;

  #       ansi = with colors.normal; [
  #         black red green yellow blue magenta cyan white
  #       ];
  #       brights = with colors.bright; [
  #         black red green yellow blue magenta cyan white
  #       ];

  #       tab_bar = {
  #         background = colors.tab.inactive.background;
  #         active_tab = {
  #           bg_color = colors.tab.active.background;
  #           fg_color = colors.tab.active.foreground;
  #         };
  #         inactive_tab = {
  #           bg_color = colors.tab.inactive.background;
  #           fg_color = colors.tab.inactive.foreground;
  #         };
  #       };
  #     };
  #   };
  # };

  programs.zsh = {
    enable = true;

    package = pkgs.emptyDirectory;

    dotDir = "${config.xdg.dataHome}/zsh";

    initContent = ''
        compinit -d "${config.xdg.cacheHome}"/zsh/zcompdump-"$ZSH_VERSION"
        . ~/dot/zshrc
    '';
  };

  programs.git = {
    enable = true;
    
    package = pkgs.emptyDirectory;

    userName = "Yusuf Bham";
    userEmail = "ybham6@gmail.com";

    difftastic = {
        color = "always";
        enable = true;
    };
  };

  nix = {
    package = pkgs.nix;
    settings.use-xdg-base-directories = true;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  programs.atuin = {
      enable = true;

      settings = {
          search_mode = "skim";
          enter_accept = false;
          style = "compact";
          inline_height = 30;
      };

      flags = [ "--disable-up-arrow" ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
