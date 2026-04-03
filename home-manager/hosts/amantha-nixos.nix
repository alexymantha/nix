{pkgs, ...}: {
  imports = [
    ../nixos/home.nix
    ../home.nix
  ];

  home.packages = [
    pkgs.prismlauncher
    # for strimzi dev
    # TODO: remoe when done
    pkgs.jetbrains.idea
    pkgs.javaPackages.compiler.temurin-bin.jdk-17
    pkgs.maven
  ];
}
