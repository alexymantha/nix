
{
  ...
}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        before_sleep_cmd = "loginctl lock-session";
        lock_cmd = "lock-screen";
        inhibit_sleep = 3; # wait until screen is locked
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
