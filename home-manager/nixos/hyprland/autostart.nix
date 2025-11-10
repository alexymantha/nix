{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    swaybg
    polkit_gnome
  ]; 
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "uwsm app -- hypridle"
      "uwsm app -- mako"
      "uwsm app -- waybar"
      "uwsm app -- swaybg -i ~/.config/omarchy/current/background -m fill"
      "uwsm app -- walker --gapplication-service &"
      "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      "wl-clip-persist --clipboard regular --all-mime-type-regex '^(?!x-kde-passwordManagerHint).+'"
    ];
  };
}
