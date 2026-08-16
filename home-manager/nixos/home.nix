{ pkgs, ... }:
{
  imports = [
    ../home.nix
  ];

  home.packages = [
    pkgs.vulkan-headers
    pkgs.vulkan-loader
    pkgs.vulkan-tools
  ];
}
