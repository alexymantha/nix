{ pkgs, ... }:
{
  imports = [
    ../nixos/home.nix
    ../home.nix
  ];

  home.packages = [
    pkgs.prismlauncher
    pkgs.claude-code
  ];
}
