{
  inputs,
  outputs,
  ...
}: {
  homebrew = {
    casks = [
      "cloudflare-warp"
      "discord"
    ];
  };

  nix.linux-builder.enable = true;
  system.defaults = {
    dock = {
      persistent-apps = [
        "/Applications/Discord.App"
      ];
    };
  };
}
