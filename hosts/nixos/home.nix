{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users = {
    amantha = {
      name = "amantha";
      home = "/home/amantha";
    };
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      # Import your home-manager configuration
      amantha = import ../../home-manager/nixos/home.nix;
    };
  };
}
