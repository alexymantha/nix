{ pkgs, ... }:
let
  zellij-sessionizer = pkgs.stdenv.mkDerivation {
    name = "zellij-sessionizer";
    src = ./zellij-sessionizer.bash;

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/zellij-sessionizer
      chmod +x $out/bin/zellij-sessionizer
    '';
  };
in
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = [
    zellij-sessionizer
  ];

  home.file.".config/zellij/config.kdl" = {
    source = ./zellij.kdl;
  };

  home.file.".config/zellij/layouts/default.kdl" = {
    text = builtins.replaceStrings [ "ZJSTATUS_PATH" ] [ "${pkgs.zjstatus}" ] (
      builtins.readFile ./default.kdl
    );
  };
}
