{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  users.users = {
    amantha = {
      shell = pkgs.fish;
      name = "amantha";
      home = "/Users/amantha";
    };
  };
}
