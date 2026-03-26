{
  pkgs,
  inputs,
  system,
  ...
}:
{
  imports = [
    ./home.nix
    ./yubikey.nix
    inputs.agenix.nixosModules.default
  ];

  nix = {
    package = pkgs.nix;
    channel.enable = false;
    settings = {
      experimental-features = "nix-command flakes";

      trusted-users = [
        "root"
        "amantha"
      ];

      # Lix-specific recommended settings
      always-allow-substitutes = true;

      # Resolve <nixpkgs> via flake registry for legacy commands (nix-shell, nix-build)
      extra-nix-path = "nixpkgs=flake:nixpkgs";

      # Show (nix:shell-name) in nix develop/nix-shell prompts
      bash-prompt-prefix = "(nix:$name)\\040";

      # Add Lix cache alongside your existing caches
      substituters = [
        "https://cache.lix.systems"
        "https://alexymantha.cachix.org"
        "https://devenv.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "alexymantha.cachix.org-1:yUrFTN9X9HjjMhMrHSV+iDY0r+ZRdVUPisI6Io4PrOc="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
  };

  programs.fish.enable = true;
  programs.zsh.enable = true;
  programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

  security.pam.services.sudo_local.touchIdAuth = true;
  system.primaryUser = "amantha";
  system.defaults = {
    NSGlobalDomain = {
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      "com.apple.swipescrolldirection" = false;
    };
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.01;
      persistent-apps = [
        "/Applications/Firefox.App"
        "/Applications/Ghostty.App"
      ];
    };
  };

  homebrew = {
    enable = true;

    taps = [ ];
    brews = [ ];
    casks = [ "ghostty" ];
  };

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    rsync
  ];

  system.stateVersion = 5;
}
