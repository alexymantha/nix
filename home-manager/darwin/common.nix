{
  config,
  pkgs,
  ...
}: {
  home = {
    packages = with pkgs; [
      raycast
      # Common packages
    ];
  };
}
