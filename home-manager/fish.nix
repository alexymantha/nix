{
  lib,
  pkgs,
  ...
}:
let
  ayu = builtins.fromTOML (builtins.readFile ./ayu.toml);
in
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = ayu // {
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
    generateCompletions = false;
    enable = true;
    interactiveShellInit = ''
      set -U fish_greeting

      # Auto-start zellij on interactive shells (see zellij.dev/documentation/integration.html)
      set ZELLIJ_AUTO_ATTACH true
      set ZELLIJ_AUTO_EXIT true
      eval (zellij setup --generate-auto-start fish | string collect)
    '';
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
    functions = {
      fish_should_add_to_history = {
        description = "Filter sensitive commands from history";
        # Best effort to avoid keeping sensitive credentials
        body = ''
          # leading space = private (replicates default behavior)
          string match -qr '^\s' -- $argv[1]; and return 1

          # sensitive argument patterns
          string match -qri -- '[-]password=|[-]secret=|[-]token=|[-]api[-_]?key=' $argv[1]; and return 1

          # specific commands that always carry secrets
          string match -qr -- '^oathtool\b' $argv[1]; and return 1

          # inline env vars with secrets
          string match -qri -- '(?:VAULT_TOKEN|AWS_SECRET_ACCESS_KEY|AWS_SESSION_TOKEN)=["\x27]?(?![$(])' $argv[1]; and return 1

          return 0
        '';
      };
    };
  };
}
