{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users = {
    amantha = {
      name = "amantha";
      home = "/home/amantha";
      shell = pkgs.fish;
    };
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      # Import your home-manager configuration
      amantha = import ../../home-manager/hosts/amantha-nixos.nix;
    };
  };
}
