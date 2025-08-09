{ swaynccfg = {
  "$schema" = "/etc/xdg/swaync/configSchema.json";
  positionX = "right";
  positionY = "top";
  "control-center-margin-top" = 10;
  "control-center-margin-bottom" = 10;
  "control-center-margin-right" = 10;
  "notification-icon-size" = 64;
  "notification-body-image-height" = 100;
  "notification-body-image-width" = 200;
  timeout = 10;
  "timeout-low" = 5;
  "timeout-critical" = 0;
  "fit-to-screen" = false;
  "control-center-width" = 500;
  "control-center-height" = 1033;
  "notification-window-width" = 500;
  "keyboard-shortcuts" = true;
  "image-visibility" = "when-available";
  "transition-time" = 200;
  "hide-on-clear" = false;
  "hide-on-action" = true;
  "script-fail-notify" = true;
  widgets = [
    "buttons-grid"
    "volume"
    "mpris"
  ];
  "widget-config" = {
    title = {
      text = "Notification Center";
      "clear-all-button" = true;
      "button-text" = builtins.fromJSON ''"\udb80\uddb4 Clear"'';
    };
    dnd = {
      text = "Do Not Disturb";
    };
    label = {
      "max-lines" = 1;
      text = "Notification Center";
    };
    mpris = {
      "image-size" = 50;
      "image-radius" = 5;
    };
    volume = {
      label = builtins.fromJSON ''"\udb81\udd7e"'';
    };
    backlight = {
      label = builtins.fromJSON ''"\udb80\udcdf"'';
    };
    "buttons-grid" = {
      actions = 
        map (builtins.mapAttrs (n: v: builtins.fromJSON ''"${v}"''))
        [
        {
          label = ''\udb81\udc25'';
          command = "systemctl poweroff";
        }
        {
          label = ''\udb81\udf09'';
          command = "systemctl reboot";
        }
        {
          label = ''\udb80\udf3e'';
          command = "swaylock-corrupter";
        }
        {
          label = ''\udb80\udf43'';
          command = "swaymsg exit";
        }
        {
          label = ''\udb80\uddb4'';
          command = "swaync-client -C";
        }
        {
          label = ''\udb81\udd7e'';
          command = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          type = "toggle";
        }
        {
          label = ''\udb80\udf6c'';
          command = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          type = "toggle";
        }
        {
          label = ''\udb81\udda9'';
          command = "iwgtk";
        }
      ];
    };
  };
};
}
