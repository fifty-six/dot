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
  ];
}
