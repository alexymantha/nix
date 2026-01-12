{
  inputs,
  outputs,
  pkgs,
  ...
}:
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
    enable = true;

    taps = [ ];
    brews = [
      "openjdk"
    ];
  };

  environment.systemPackages = with pkgs; [
    docker
    colima
    zellij-switch
  ];
}
