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

  services.tailscale.enable = true;

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      amantha = import ../../../home-manager/hosts/amantha-air.nix;
    };
  };
}
