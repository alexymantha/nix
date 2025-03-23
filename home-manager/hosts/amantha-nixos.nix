{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../nixos/home.nix
    ../home.nix
  ];

  home.packages = with pkgs; [
    prismlauncher
  ];
}
