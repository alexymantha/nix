{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  security.pki.certificateFiles = ["/etc/ssl/certs/all_trusted_certs.pem"];

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      amantha = import ../../../home-manager/hosts/amantha-mbp.nix;
    };
  };

  environment.systemPackages = with pkgs; [
    docker
  ];
}
