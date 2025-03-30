{
  pkgs,
  inputs,
  system,
  ...
}: {
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

      trusted-users = ["root" "amantha"];

      substituters = [
        "https://alexymantha.cachix.org"
        "https://devenv.cachix.org"
      ];

      trusted-public-keys = [
        "alexymantha.cachix.org-1:yUrFTN9X9HjjMhMrHSV+iDY0r+ZRdVUPisI6Io4PrOc="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };
  };

  programs.zsh.enable = true;
  programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";

  security.pam.enableSudoTouchIdAuth = true;
  # security.pam.services.sudo_local.touchIdAuth = true;
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
        "/Applications/WezTerm.App"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.system}.default
    rsync
  ];

  system.stateVersion = 5;
}
