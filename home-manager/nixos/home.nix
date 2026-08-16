{ pkgs, ... }:
{
  imports = [
    ./hyprland/hyprland.nix
    ../home.nix
    ./omarchy.nix
  ];

  home.packages = [
    pkgs.firefox
    pkgs.vulkan-headers
    pkgs.vulkan-loader
    pkgs.vulkan-tools
    pkgs.gnome-calculator
    pkgs.gnome-keyring
    pkgs.gnome-themes-extra
    pkgs.pamixer
    pkgs.playerctl
    pkgs.unstable.wiremix
  ];
}
