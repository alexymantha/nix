{pkgs, inputs, ...}: {
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = [
      inputs.zellij-switch
  ];

  home.file.".config/zellij/config.kdl" = {
    source = ./zellij.kdl;
  };

  home.file.".config/zellij/layouts/default.kdl" = {
    text =
      builtins.replaceStrings
      ["ZJSTATUS_PATH"]
      ["${pkgs.zjstatus}"]
      (builtins.readFile ./default.kdl);
  };
}
