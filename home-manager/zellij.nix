{pkgs, ...}: {
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file.".config/zellij/config.kdl" = {
    source = ./zellij.kdl;
  };

  home.file.".config/zellij/layouts/default.kdl" = {
    text = builtins.replaceStrings 
      ["ZJSTATUS_PATH"] 
      ["${pkgs.zjstatus}"]
      (builtins.readFile ./default.kdl);
  };
}
