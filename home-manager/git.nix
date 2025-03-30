{
  config,
  pkgs,
  ...
}: let
  getSigningKey = pkgs.writeShellScriptBin "get_signing_key" ''
    ssh-add -L | grep "9c" | awk '$0="key::"$0'
  '';
in {
  programs.git = {
    enable = true;
    userName = "Alexy Mantha";
    userEmail = "alexy@mantha.dev";
    extraConfig = {
      commit = {
        gpgsign = true;
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
