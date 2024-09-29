{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  users.users = {
    amantha = {
      name = "amantha";
      home = "/Users/amantha";
    };
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      # Import your home-manager configuration
      amantha = import ../../home-manager/home.nix;
    };
  };
}
