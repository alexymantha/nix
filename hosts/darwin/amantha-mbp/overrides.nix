{
  inputs,
  outputs,
  pkgs,
  ...
}:
let
  signSshKeyVersion = "1.4.3";

  sign-ssh-key = pkgs.stdenv.mkDerivation {
    pname = "sign-ssh-key";
    version = signSshKeyVersion;

    src = pkgs.fetchzip {
      url = "https://artifactory.prodwest.citrixsaassbe.net/artifactory/generic-release/dvp/sign-ssh-key/${signSshKeyVersion}/sign-ssh-key-${signSshKeyVersion}.zip";
      hash = "sha256-v0/n4vV2YkfB0D8fujh1CWoNkMbVwQGhDqWnmPc1Owk=";
    };

    installPhase = ''
      install -Dm755 bin/sign-ssh-key $out/bin/sign-ssh-key
    '';
  };
in
{
  nix.settings.ssl-cert-file = "/etc/ssl/certs/all_trusted_certs.pem";
  security.pki.certificateFiles = [ "/etc/ssl/certs/all_trusted_certs.pem" ];

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      amantha = import ../../../home-manager/hosts/amantha-mbp.nix;
    };
  };

  homebrew = {
    taps = [ ];
    casks = [
      "copilot-cli"
    ];
    brews = [
      "openjdk"
      "maven"
    ];
  };

  environment.systemPackages = [
    pkgs.docker
    pkgs.vault
    pkgs.zellij-switch 
    sign-ssh-key
  ];
}
