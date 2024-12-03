{ config, pkgs, ... }:
{
  imports = [
    ../darwin/common.nix
    ../home.nix
  ];

  home.packages = with pkgs; [
    # Work
    awscli2
    azure-cli
    docker
    gh
    kustomize
    vault
    gnupg
  ];
}
