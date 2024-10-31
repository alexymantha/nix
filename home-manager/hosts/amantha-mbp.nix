{ config, pkgs, ... }:
{
  imports = [
    ../darwin/common.nix
    ../home.nix
  ];

  home.packages = with pkgs; [
    awscli2
    docker
  ];
}