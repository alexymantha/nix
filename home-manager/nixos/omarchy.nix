# Most of the Hyprland config is based on Omarchy
# So this will install all the scripts provided by omarchy
{pkgs, ...}: let
  scriptDir = "bin";

  # Create a derivation that extracts and installs the scripts
  omarchy-scripts = pkgs.stdenv.mkDerivation {
    name = "omarchy-scripts";
    src = pkgs.omarchy-src;

    installPhase = ''
      mkdir -p $out/bin

      # Copy all scripts from the specific directory
      if [ -d "${scriptDir}" ]; then
        cp -r ${scriptDir}/* $out/bin/

        # Make all files in bin executable
        chmod +x $out/bin/*
      else
        echo "Warning: Directory ${scriptDir} not found in repository"
      fi
    '';
  };
in {
  home.packages = [
    omarchy-scripts
  ];
}
