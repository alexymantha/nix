{
  config,
  lib,
  pkgs,
  ...
}: let
  zellij-sessionizer = pkgs.stdenv.mkDerivation {
    name = "zellij-sessionizer";
    src = ./zellij-sessionizer.bash;

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/zellij-sessionizer
      chmod +x $out/bin/zellij-sessionizer
    '';
  };
in {
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = [
    zellij-sessionizer
  ];

  home.file.".config/zellij/config.kdl" = {
    source = ./zellij.kdl;
  };

  home.file.".config/zellij/layouts/default.kdl" = {
    text = builtins.replaceStrings ["ZJSTATUS_PATH"] ["${pkgs.zjstatus}"] (
      builtins.readFile ./default.kdl
    );
  };

  # Every rebuild gives zjstatus a new /nix/store path, and zellij keys its
  # plugin permission cache (~/.cache/zellij/permissions.kdl) by exact path.
  # That means each rebuild re-triggers zjstatus's "grant permissions? y/n"
  # prompt - but that prompt renders inside the 1-row borderless status bar
  # pane, where it's unreadable/invisible (upstream zellij issue #4749), so
  # it looks like the status bar silently stopped working. Pre-grant the
  # permissions for the current store path so the prompt never needs to
  # appear. See https://github.com/zellij-org/zellij/issues/4982 for why
  # editing permissions.kdl directly is the documented workaround.
  home.activation.zjstatusPermissions = lib.hm.dag.entryAfter ["writeBoundary"] ''
    permFile="${config.home.homeDirectory}/.cache/zellij/permissions.kdl"
    pluginPath="${pkgs.zjstatus}/bin/zjstatus.wasm"
    run mkdir -p "$(dirname "$permFile")"
    run touch "$permFile"
    if ! ${pkgs.gnugrep}/bin/grep -qF "\"$pluginPath\"" "$permFile"; then
      run bash -c "printf '%s\n' \
        '\"$pluginPath\" {' \
        '    ReadApplicationState' \
        '    ChangeApplicationState' \
        '    RunCommands' \
        '}' >> \"$permFile\""
    fi
  '';
}
