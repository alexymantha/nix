{ pkgs, ... }:
{
  imports = [
    ../home.nix
  ];

  home.packages = [
    pkgs.vulkan-headers
    pkgs.vulkan-loader
    pkgs.vulkan-tools
    pkgs.unstable.discord
  ];

  # Lets Steam Big Picture be launched nested in a window from the app
  # launcher, without having to log out and pick the dedicated "Steam"
  # gamescope session from SDDM.
  xdg.desktopEntries.steam-gamescope = {
    name = "Steam (Gamescope)";
    comment = "Launch Steam Big Picture in a nested Gamescope window";
    icon = "steam";
    exec = "gamescope -f -- steam -gamepadui -pipewire-dmabuf";
    terminal = false;
    categories = [ "Game" ];
  };
}
