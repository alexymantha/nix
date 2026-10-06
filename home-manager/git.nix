{
  config,
  lib,
  pkgs,
  ...
}: let
  # Git uses a dedicated passphrase-protected key instead of the YubiKey agent,
  # which stays the default SSH_AUTH_SOCK for everything else.
  gitKey = "${config.home.homeDirectory}/.ssh/id_ed25519_git";

  # macOS: Apple's ssh reads the passphrase from the login Keychain (UseKeychain),
  # so no agent is needed. Nix's openssh does not support UseKeychain.
  # Linux: a separate ssh-agent caches the key; ksshaskpass stores the
  # passphrase in KWallet, which is unlocked at login.
  gitSshCommand =
    if pkgs.stdenv.isDarwin
    then "/usr/bin/ssh -i ${gitKey} -o IdentitiesOnly=yes -o IdentityAgent=none -o UseKeychain=yes"
    else "SSH_ASKPASS=${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass SSH_ASKPASS_REQUIRE=prefer ssh -i ${gitKey} -o IdentitiesOnly=yes -o IdentityAgent=$XDG_RUNTIME_DIR/ssh-agent-git.sock -o AddKeysToAgent=yes";

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
      core.sshCommand = gitSshCommand;
      user.signingkey = "${gitKey}.pub";
      gpg.format = "ssh";
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
    gitCredentialLibsecret
  ];

  systemd.user.services.ssh-agent-git = lib.mkIf pkgs.stdenv.isLinux {
    Unit.Description = "ssh-agent for the git SSH key";
    Service.ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a %t/ssh-agent-git.sock";
    Install.WantedBy = ["default.target"];
  };
}
