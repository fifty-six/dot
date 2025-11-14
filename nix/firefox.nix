{ pkgs, ... }:
let
  parfait = pkgs.fetchzip {
    url = "https://github.com/reizumii/parfait/archive/refs/tags/v0.8.zip";
    hash = "sha256-lx4ByjLDp4SoZuyGk5y3aKem2vp7ilCZ4Vnb6lejHKw=";
  };
in
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        # --- enable userchrome theming ---
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;

        # --- revert sidebar position to left ---
        "sidebar.position_start" = true;

        # --- set default parfait preferences ---

        /* general */
        "parfait.animations.enabled" = true;
        "parfait.blur.enabled" = false;

        /* background */
        "parfait.bg.accent-color" = false;
        "parfait.bg.contrast" = 2;
        "parfait.bg.gradient" = false;
        "parfait.bg.opacity" = 4;
        "parfait.bg.transparent" = false;

        /* tabs */
        "parfait.tabs.groups.color" = false;

        /* sidebar */
        "parfait.sidebar.width.preset" = 2;

        /* theme */
        "parfait.theme.lwt.alt" = false;
        "parfait.theme.roundness.preset" = 1;

        /* toolbar */
        "parfait.toolbar.sidebar-gutter" = true;
        "parfait.toolbar.unified-sidebar" = true;

        # traffic lights
        "parfait.traffic-lights.enabled" = false;
        "parfait.traffic-lights.mono" = false;

        # url bar
        "parfait.urlbar.url.center" = false;
        "parfait.urlbar.results.compact" = false;
        "parfait.urlbar.search-mode.glow" = true;

        /* window */
        "parfait.window.borderless" = false;

        # new tab
        "parfait.new-tab.logo" = 1;
        "parfait.new-tab.bg.pattern" = false;
      };

      userChrome = ''@import "parfait/userChrome.css";'';
      userContent = ''@import "parfait/userContent.css";'';
    };
  };

  home.file.parfait = {
    source = parfait;
    target = ".mozilla/firefox/default/chrome/parfait";
  };
}
