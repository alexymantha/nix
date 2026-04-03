{pkgs, ...}: {
  imports = [
    ../darwin/common.nix
    ../home.nix
  ];

  home.packages = [
    pkgs.discord
    pkgs.ruby
  ];
}
