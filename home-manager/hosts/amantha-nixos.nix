{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../nixos/home.nix
    ../home.nix
  ];

  home.packages = with pkgs; [
    prismlauncher
    # for strimzi dev
    # TODO: remoe when done
    jetbrains.idea
    javaPackages.compiler.temurin-bin.jdk-17
    maven
  ];
}
