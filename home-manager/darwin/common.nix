{
  config,
  pkgs,
  ...
}: {
  home = {
    packages = with pkgs; [
      # Common packages
    ];
  };
}
