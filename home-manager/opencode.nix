{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.opencode;
  isWork = cfg.profile == "work";

  # Only these files are managed. agents/ and skills/ stay regular directories
  # so host-specific (e.g. work) agents and skills can be added by hand.
  sharedFiles = [
    "AGENTS.md"
    "tui.json"
    "agents/agent-builder.md"
    "agents/code-review.md"
    "agents/log-analyzer.md"
    "agents/researcher.md"
    "agents/skill-builder.md"
    "agents/technical-writer.md"
    "skills/unslop/SKILL.md"
  ];

  sensitiveFiles = {
    "**/.env*" = "deny";
    "**/*.key" = "deny";
    "**/*.pem" = "deny";
    "**/*.p12" = "deny";
    "**/*.secret" = "deny";
    "**/.ssh/**" = "deny";
  };

  commonSettings = {
    "$schema" = "https://opencode.ai/config.json";
    instructions = ["skills/unslop/SKILL.md"];
    share = "disabled";
    autoupdate = "notify";
    permission = {
      read = {"*" = "allow";} // sensitiveFiles;
      edit = {"*" = "allow";} // sensitiveFiles;
      bash = {
        "rm -rf *" = "ask";
        "rm -r *" = "ask";
        "sudo *" = "deny";
        "kubectl *" = "ask";
      };
    };
  };

  workSettings = {
    experimental.policies = [
      {
        effect = "deny";
        action = "provider.use";
        resource = "*";
      }
      {
        effect = "allow";
        action = "provider.use";
        resource = "github-copilot";
      }
    ];
    model = "github-copilot/gpt-5.6-sol";
    small_model = "github-copilot/gpt-5.6-luna";
    agent = {
      plan = {
        model = "github-copilot/claude-opus-5";
        permission = {
          edit = "deny";
          bash = "deny";
          task = "deny";
        };
      };
      build.model = "github-copilot/gpt-5.6-sol";
      explore.model = "github-copilot/gpt-5.4-mini";
      general.model = "github-copilot/gpt-5.6-terra";
      title.model = "github-copilot/gpt-5.6-luna";
      summary.model = "github-copilot/gpt-5.6-terra";
      compaction.model = "github-copilot/claude-sonnet-5";
    };
  };

  personalSettings = {
    model = "anthropic/claude-sonnet-5";
    agent = {
      plan = {
        model = "anthropic/claude-sonnet-5";
        permission.edit = "deny";
      };
      build.model = "anthropic/claude-sonnet-5";
    };
    plugin = ["@ex-machina/opencode-anthropic-auth@next"];
    # The HA MCP server embeds a bearer-style token directly in the webhook
    # URL, so it can't use opencode's {env:...} substitution. The real URL is
    # age-encrypted and spliced in at activation so it never reaches the
    # nix store or git history.
    mcp = lib.optionalAttrs cfg.homeAssistant.enable {
      ha = {
        type = "remote";
        url = "__HA_WEBHOOK_URL__";
      };
    };
  };

  # builtins.toJSON sorts keys and opencode applies the last matching
  # permission rule, so wildcard keys (e.g. "*") must sort before the
  # more specific rules they are overridden by.
  settings = lib.recursiveUpdate commonSettings (
    if isWork
    then workSettings
    else personalSettings
  );

  configFile = pkgs.writeText "opencode.json" (builtins.toJSON settings);

  secretFile = ../secrets/opencode-ha-webhook-url.age;
  identityPath = "${config.home.homeDirectory}/.config/age/keys.txt";
  needsSecret = !isWork && cfg.homeAssistant.enable;
in {
  options.modules.opencode = {
    profile = lib.mkOption {
      type = lib.types.enum ["personal" "work"];
      default = "personal";
      description = ''
        "work" uses GitHub Copilot only and loads ~/.config/opencode/work.json
        (unmanaged) through OPENCODE_CONFIG for work-specific settings.
        "personal" uses Anthropic with the Home Assistant MCP server.
      '';
    };

    homeAssistant.enable = lib.mkOption {
      type = lib.types.bool;
      default = !isWork;
      description = ''
        Whether to configure the Home Assistant remote MCP server. The
        webhook URL is decrypted from secrets/opencode-ha-webhook-url.age at
        activation time using the age identity at ~/.config/age/keys.txt.
      '';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf isWork {
      # Work-specific config (MCP servers etc.) lives in an unmanaged file so
      # it never enters this repo. opencode merges it on top of opencode.json.
      home.sessionVariables.OPENCODE_CONFIG = "${config.xdg.configHome}/opencode/work.json";
    })

    {
      home.packages = [pkgs.opencode];
      xdg.configFile = lib.genAttrs (map (f: "opencode/${f}") sharedFiles) (name: {
        source = ./configs + "/${name}";
      });
    }

    (lib.mkIf (!needsSecret) {
      xdg.configFile."opencode/opencode.json".source = configFile;
    })

    (lib.mkIf needsSecret {
      # Contains a decrypted secret, so this must be a real file written
      # at activation time, not a symlink into the world-readable store.
      home.activation.opencodeConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
        target="${config.home.homeDirectory}/.config/opencode/opencode.json"
        run mkdir -p "$(dirname "$target")"
        if [ -f "${identityPath}" ]; then
          webhook_url="$(${pkgs.age}/bin/age -d -i "${identityPath}" "${secretFile}")"
          ${pkgs.gnused}/bin/sed "s|__HA_WEBHOOK_URL__|$webhook_url|" "${configFile}" > "$target.tmp"
          run mv "$target.tmp" "$target"
          run chmod 600 "$target"
        else
          warnEcho "[opencode] ${identityPath} not found; leaving $target untouched. Decrypt manually with: age -d -i <identity> ${secretFile}, then rerun the home-manager switch."
        fi
      '';
    })
  ];
}
