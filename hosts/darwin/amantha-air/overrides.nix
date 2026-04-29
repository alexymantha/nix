{
  inputs,
  outputs,
  ...
}: {
  nix = {
    linux-builder.enable = true;

    settings.trusted-users = ["@admin"];
  };

  system.defaults = {
    dock = {
      persistent-apps = [
        "/Applications/Discord.App"
      ];
    };
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      amantha = import ../../../home-manager/hosts/amantha-air.nix;
    };
  };
}
