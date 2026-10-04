{inputs, ...}: {
  additions = final: prev: {
    zjstatus = inputs.zjstatus.packages.${final.stdenv.hostPlatform.system}.default;
    # Defined locally rather than using `inputs.zellij-switch.overlays.default`,
    # which uses the deprecated `prev.system` and emits an eval warning.
    zellij-switch = inputs.zellij-switch.packages.${final.stdenv.hostPlatform.system}.default;
    omarchy-src = final.fetchFromGitHub {
      owner = "basecamp";
      repo = "omarchy";
      rev = "v3.0.2";
      sha256 = "sha256-1QJBoMe6MzaD/dcOcqC8QpRxG0Z2c1p+WYqtNFlsTOA=";
    };
    # opencode v2 straight from upstream's own flake until nixpkgs
    # packages it (see the `opencode` input for details).
    opencode = (inputs.opencode.packages.${final.stdenv.hostPlatform.system}.opencode).overrideAttrs (old: {
      # Upstream's own nix/opencode.nix still shells out to the removed
      # `opencode completion` subcommand, which crashes trying to chdir
      # into a `completion/` directory that no longer exists in v2.0.22
      # (see the nixpkgs packaging PR for opencode 2.0.22:
      # https://github.com/NixOS/nixpkgs/pull/569770, which fixes this by
      # switching to `--completions <shell>`). Apply the same fix here.
      postInstall = final.lib.optionalString (final.stdenv.buildPlatform.canExecute final.stdenv.hostPlatform) ''
        installShellCompletion --cmd opencode \
          --bash <($out/bin/opencode --completions bash) \
          --zsh <($out/bin/opencode --completions zsh) \
          --fish <($out/bin/opencode --completions fish)

        installShellCompletion --cmd opencode2 \
          --bash <($out/bin/opencode2 --completions bash) \
          --zsh <($out/bin/opencode2 --completions zsh) \
          --fish <($out/bin/opencode2 --completions fish)
      '';
    });
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    direnv = prev.direnv.overrideAttrs (old: {
      doCheck = false;
    });
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
