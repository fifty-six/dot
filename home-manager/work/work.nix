{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../common.nix
    ../work-common.nix
  ];

  home.username = "yusuf.bham@zetier.com";
  home.homeDirectory = "/home/yusuf.bham";

  home.packages = [
    pkgs.neovim
    pkgs.fzf
    pkgs.ripgrep
    pkgs.bat
    pkgs.fd
    pkgs.uv
    pkgs.jujutsu
    pkgs.eza
    pkgs.hyperfine
    pkgs.lua-language-server
    pkgs.typescript-language-server
    pkgs.evil-helix
    pkgs.mosh
    pkgs.glow
  ];

  programs.atuin.settings.daemon.enabled = true;

  systemd.user.services.atuin-daemon = {
    Unit = {
      Description = "Atuin daemon";

      After = ["graphical-session.target"];
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.atuin}/bin/atuin daemon";
    };
  };
}
