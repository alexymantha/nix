{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../darwin/common.nix
    ../home.nix
  ];

  home.packages = with pkgs; [
    # Work
    awscli2
    azure-cli
    unstable.opentofu
    terraform
    docker
    gh
    kustomize
    vault
    gnupg
    kyverno
    unstable.opencode
  ];

  home.sessionVariables = {
    NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/all_trusted_certs.pem";
    SSL_CERT_FILE = "/etc/ssl/certs/all_trusted_certs.pem";
    AWS_CA_BUNDLE = "/etc/ssl/certs/all_trusted_certs.pem";
  };
}
