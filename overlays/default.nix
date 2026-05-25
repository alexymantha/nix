{inputs, ...}: {
  additions = final: prev: {
    zjstatus = inputs.zjstatus.packages.${final.stdenv.hostPlatform.system}.default;
    omarchy-src = final.fetchFromGitHub {
      owner = "basecamp";
      repo = "omarchy";
      rev = "v3.0.2";
      sha256 = "sha256-1QJBoMe6MzaD/dcOcqC8QpRxG0Z2c1p+WYqtNFlsTOA=";
    };
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    direnv = prev.direnv.overrideAttrs (old: {
      doCheck = false;
    });
    fish = (import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    }).fish;
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}
