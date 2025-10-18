{ config, pkgs, lib, ... }:

let
    HOME = builtins.getEnv "HOME";
    inherit (import ./colors.nix) colors;
    mklink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.stateVersion = "25.11";

  home.packages = [
    pkgs.nixd
    pkgs.ntfy-sh
    pkgs.jjui
    pkgs.comma
    pkgs.nix-output-monitor
    pkgs.basedpyright
    pkgs.alejandra
    pkgs.eza
  ];

  home.file = {
    ".local/share/zsh/.zimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dot/zimrc";
  };

  xdg.configFile = {
    "latexmk/latexmkrc".text = ''
        $pdflatex = 'pdflatex --shell-escape %O %S';
    '';
    "chromium-flags.conf".text = ''
        --enable-features=VaapiVideoDecoder,VaapiIgnoreDriverChecks
        --enable-gpu-rasterization
        --ignore-gpu-blacklist
        --enable-zero-copy
        --disable-gpu-driver-workarounds
        --ozone-platform-hint=auto
    '';

    "nvim".source = mklink "${config.home.homeDirectory}/dot/nvim";
    "ncdu/config".text = "--color dark";
    "wezterm/config.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dot/wezterm.lua";
    "ntfy/client.yml".source = ./../ntfy.yml;
    "jj/config.toml".source = ./../jj/jj.toml;
    "niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dot/niri.kdl";
  };

  home.sessionVariables = {
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/state/nix/profile/bin"
    "${config.home.homeDirectory}/.local/share/dotnet/.dotnet/tools"

    "${config.xdg.dataHome}/npm/bin"

    "${config.home.homeDirectory}/dot/bin"
  ];

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
        size = if pkgs.stdenv.isDarwin then 18 else 12;
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
    };
  };

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

  nix = lib.mkDefault {
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
