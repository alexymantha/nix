{
  config,
  pkgs,
  ...
}: let
  getSigningKey = pkgs.writeShellScriptBin "get_signing_key" ''
    ssh-add -L | grep "9c" | awk '$0="key::"$0'
  '';
in {
  programs.delta.enable = true; # Prettier diff viewer
  programs.delta.enableGitIntegration = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Alexy Mantha";
        email = "alexy@mantha.dev";
      };
      commit = {
        gpgsign = false;
        template = "${config.home.homeDirectory}/.gitmessage";
      };
      gpg = {
        format = "ssh";
        ssh = {
          defaultKeyCommand = "${getSigningKey}/bin/get_signing_key";
        };
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };

  home.packages = [
    getSigningKey
  ];
}
