{
  config,
  pkgs,
  ...
}: let
  getSigningKey = pkgs.writeShellScriptBin "get_signing_key" ''
    ssh-add -L | grep "9c" | awk '$0="key::"$0'
  '';

  # Standalone libsecret credential helper, extracted from a git build with
  # withLibsecret enabled. Only this single binary is installed (not the
  # whole git derivation) so it doesn't collide with programs.git's own git
  # package. Scoped to specific hosts below, not used as the default helper.
  gitCredentialLibsecret = pkgs.runCommand "git-credential-libsecret" {} ''
    mkdir -p $out/bin
    cp ${pkgs.git.override {withLibsecret = true;}}/libexec/git-core/git-credential-libsecret $out/bin/
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
      # Only use the libsecret credential helper for this Gitea host; every
      # other remote keeps its own default (none, in this case).
      credential."https://gitea.homelab.mantha.org" = {
        helper = "libsecret";
      };
    };
  };

  home.file.".gitmessage".text = ''


    Signed-off-by: Alexy Mantha <alexy@mantha.dev>
  '';

  home.packages = [
    getSigningKey
    gitCredentialLibsecret
  ];
}
