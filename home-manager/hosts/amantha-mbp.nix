{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../darwin/common.nix
    ../home.nix
  ];

  home.packages = [
    # Work
    pkgs.awscli2
    pkgs.azure-cli
    pkgs.unstable.opentofu
    pkgs.terraform
    pkgs.docker
    pkgs.gh
    pkgs.kustomize
    pkgs.vault
    pkgs.gnupg
    pkgs.kyverno
    pkgs.kubelogin-oidc
    pkgs.unstable.colima
    pkgs.unstable.claude-code
  ];

  programs.git = {
    settings = {
      user = {
        email = lib.mkForce "alexy.mantha@goto.com";
      };
    };
  };
  home.file.".gitmessage".text = lib.mkForce ''


    Signed-off-by: Alexy Mantha <alexy.mantha@goto.com>
  '';

  home.sessionVariables = {
    NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/all_trusted_certs.pem";
    SSL_CERT_FILE = "/etc/ssl/certs/all_trusted_certs.pem";
    AWS_CA_BUNDLE = "/etc/ssl/certs/all_trusted_certs.pem";
  };
}
