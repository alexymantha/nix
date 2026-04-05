{ pkgs, ... }:
{
  services.hypridle = {
    enable = true;
    package = pkgs.unstable.hypridle;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        before_sleep_cmd = "loginctl lock-session";
        lock_cmd = "lock-screen";
        inhibit_sleep = 3;
      };
      listener = [
        {
          on-timeout = "pidof hyprlock || launch-screen-saver";
          timeout = 150;
        }
        {
          on-timeout = "loginctl lock-session";
          timeout = 300;
        }
        {
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
          timeout = 330;
        }
      ];
    };
  };
}

