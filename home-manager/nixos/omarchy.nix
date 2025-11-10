# Most of the Hyprland config is based on Omarchy 
# So this will install all the scripts provided by omarchy
{ pkgs, ... }:

let
  owner = "basecamp";
  repo = "omarchy";
  rev = "v3.0.2";
  scriptDir = "bin";
  
  # Fetch the repository
  repoSrc = pkgs.fetchFromGitHub {
    owner = owner;
    repo = repo;
    rev = rev;
    sha256 = "sha256-1QJBoMe6MzaD/dcOcqC8QpRxG0Z2c1p+WYqtNFlsTOA=";
  };
  
  # Create a derivation that extracts and installs the scripts
  omarchy-scripts = pkgs.stdenv.mkDerivation {
    name = "${repo}-scripts";
    src = repoSrc;
    
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

