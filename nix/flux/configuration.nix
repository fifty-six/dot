{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./services/blocky.nix
    ./services/ha.nix
    ./services/restic.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.tmp.useTmpfs = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "flux";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.toor = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    aria2
    git

    zsh
    grml-zsh-config

    # This is just for the terminfo
    kitty

    # I want _some_ cc, if only for treesitter
    clang

    # :/
    docker
    docker-compose
    # I still have some quadlets
    podman

    tmux
    ripgrep
    dig

    uv
    # Some python wheels need make
    gnumake

    hyfetch

    compose2nix

    lsof
    unixtools.netstat
  ];

  programs.zsh = {
    enable = true;
    interactiveShellInit = "source ${pkgs.grml-zsh-config}/etc/zsh/zshrc";
  };

  programs.nix-ld.enable = true;

  services.openssh.enable = true;
  services.tailscale.enable = true;
  networking.nameservers = [ "localhost" ];
  services.resolved = {
    enable = true;
    extraConfig = "DNSStubListener=no";
  };

  # :(
  virtualisation.docker = {
    enable = true;
  };

  # TODO: set env var here
  services.nixos-cli = {
    enable = true;
    config = {
      apply.use_nom = true;
      use_nvd = true;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 8080 8091 443 22 80 ];
  # networking.firewall.allowedUDPPorts = [ 8080 8091 443 22 80 ];
  # Or disable the firewall altogether.
  # TODO: firewall? esp with caddy up...
  networking.firewall.enable = false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "25.05";
}
