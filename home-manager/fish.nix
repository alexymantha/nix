{
  lib,
  pkgs,
  ...
}: let
  ayu = builtins.fromTOML (builtins.readFile ./ayu.toml);
in {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings =
      ayu
      // {
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$localip"
          "$shlvl"
          "$directory"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_metrics"
          "$git_status"
          "$custom"
          "$sudo"
          "$cmd_duration"
          "$line_break"
          "$jobs"
          "$battery"
          "$time"
          "$status"
          "$os"
          "$container"
          "$netns"
          "$shell"
          "$character"
        ];
        git_status = {
          ahead = "⇡\${count}";
          diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
          behind = "⇣\${count}";
        };
        add_newline = false;
        scan_timeout = 10;
        line_break.disabled = true;
        palette = "ayu";
      };
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = "set -U fish_greeting";
    shellAliases = {
      dev = "zellij-sessionizer";
      k = "kubectl";
      kcx = "kubectx && zellij pipe 'zjstatus::rerun::command_kubectx' && zellij pipe 'zjstatus::rerun::command_kubens'";
      kns = "kubens && zellij pipe 'zjstatus::rerun::command_kubectx' && zellij pipe 'zjstatus::rerun::command_kubens'";
      # Keeping gnu versions for a while to get used to the new versions
      cat = "bat";
      gnucat = "command cat";
      grep = "rg";
      gnugrep = "command grep";
      ls = "eza --icons --group-directories-first --color=always --long --git --header --no-permissions";
      gnuls = "command ls";
      find = "fd";
      gnufind = "command find";
    };
  };
}
