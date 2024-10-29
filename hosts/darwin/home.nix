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
}
