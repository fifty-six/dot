{ config, pkgs, lib, ... }:

{
  xdg.configFile = {
    "jj/conf.d/work.toml".source = ./../jj/work.toml;
    "jj/conf.d/dot.toml".source= ./../jj/dot.toml;
  };

  programs.git = lib.mkForce {
    settings.user.email = "yusuf.bham@zetier.com";
  };
}
