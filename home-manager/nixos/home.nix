{
  pkgs,
  ...
}: {
  imports = [
    ./hyprland/hyprland.nix
    ../home.nix
    ./omarchy.nix
  ];

  home.packages = with pkgs; [
    firefox
    vulkan-headers
    vulkan-loader
    vulkan-tools
    unstable.godot_4
    unityhub
    gnome-calculator
    gnome-keyring
    gnome-themes-extra
    pamixer
    playerctl
    unstable.wiremix
  ];
}
