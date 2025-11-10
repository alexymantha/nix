{
  ...
}: {
  wayland.windowManager.hyprland.systemd.enable = false;
  wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = "us";
      kb_variant = "";
      kb_model = "";
      kb_options = "compose:caps";
      kb_rules = "";

      # Change speed of keyboard repeat
      repeat_rate = 40;
      repeat_delay = 600;

      # Start with numlock on by default
      numlock_by_default = true;

      follow_mouse = 1;

      sensitivity = 0;

      touchpad = {
        natural_scroll = false;
      };
    };
    
    windowrule = [
      "scrolltouchpad 0.2, class:com.mitchellh.ghostty"
    ];
  };
}
