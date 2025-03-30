{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hyprland/hyprland.nix

    ../home.nix
  ];

  home.packages = with pkgs; [
    vulkan-headers
    vulkan-loader
    vulkan-tools
  ];
}
