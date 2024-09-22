{pkgs, ...}: {
  imports = [
    ./home.nix
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  programs.zsh.enable = true;
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
    taps = [
      "joallard/cf-keylayout"
    ];
    casks = [
      "cf-keylayout"
      "firefox"
      "gimp"
      "obs"
      "slack"
      "vlc"
    ];
  };

  security.pam.enableSudoTouchIdAuth = true;
  services = {
    nix-daemon.enable = true;
  };
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
        "/Applications/Discord.App"
      ];
    };
  };
}
