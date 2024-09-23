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

  system.defaults = {
    dock = {
      persistent-apps = [
        "/Applications/Discord.App"
      ];
    };
  };
}
