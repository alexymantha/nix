{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.opencode;

  # The HA MCP server embeds a bearer-style token directly in the webhook
  # URL (not in a header), so it can't use opencode's {env:...} header
  # substitution. Instead the real URL is age-encrypted at
  # secrets/opencode-ha-webhook-url.age and spliced in by the activation
  # script below, so it never touches the nix store or git history.
  mcpSection =
    if cfg.homeAssistant.enable
    then ''
      "mcp": {
          "ha": {
              "type": "remote",
              "url": "__HA_WEBHOOK_URL__"
          }
      },
    ''
    else ''"mcp": {},'';

  configText = ''
    {
        "$schema": "https://opencode.ai/config.json",
        // Disable sharing: https://opencode.ai/docs/share#disabled
        "share": "disabled",
        // Permission rules to prevent dangerous operations
        "permission": {
            "bash": {
                // Require confirmation for destructive commands
                "rm -rf *": "ask",
                "rm -r *": "ask",
                // Block sudo to prevent privilege escalation
                "sudo *": "deny",
                // Avoid applying something to the clusters
                "kubectl *": "ask",
            },
            "edit": {
                // Prevent accidental edits to sensitive files
                "**/*.env*": "deny",
                "**/*.key": "deny",
                "**/*.secret": "deny",
            },
        },
        // Custom modes for different workflows: https://opencode.ai/docs/agents/
        "mode": {
            // Planning mode: read-only
            "plan": {
                "model": "anthropic/claude-sonnet-5",
                "tools": {
                    "write": false,
                    "edit": false,
                    "bash": true,
                    "read": true,
                    "grep": true,
                    "glob": true,
                },
            },
            // Build mode: full access for implementation
            "build": {
                "model": "anthropic/claude-sonnet-5",
            },
        },
        // MCP (Model Context Protocol) servers
        ${mcpSection}
        // Custom AI providers (configure for the organization)
        "provider": {},
        // Plugins (optional)
        "plugins": [
            "@ex-machina/opencode-anthropic-auth@next"
        ],
    }
  '';

  templateFile = pkgs.writeText "opencode.jsonc.tmpl" configText;

  # Relative to this file; repo root is ../
  secretFile = ../secrets/opencode-ha-webhook-url.age;

  # Conventional age identity location. See home-manager/README or ask
  # for the manual setup steps: this file must contain the AGE-SECRET-KEY
  # that corresponds to the recipient used to encrypt secretFile.
  identityPath = "${config.home.homeDirectory}/.config/age/keys.txt";
in {
  options.modules.opencode.homeAssistant.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = ''
      Whether to configure the Home Assistant remote MCP server in
      opencode.jsonc. The webhook URL is decrypted from
      secrets/opencode-ha-webhook-url.age at activation time using the
      age identity at ~/.config/age/keys.txt. Disable on hosts (e.g. work
      laptops) that should not have HA access.
    '';
  };

  config = lib.mkMerge [
    {
      home.packages = [pkgs.opencode];
    }

    (lib.mkIf (!cfg.homeAssistant.enable) {
      # No secret involved: a plain nix-store symlink is fine.
      xdg.configFile."opencode/opencode.jsonc".text = configText;
    })

    (lib.mkIf cfg.homeAssistant.enable {
      # Contains a decrypted secret, so this must be a real file written
      # at activation time, not a symlink into the world-readable store.
      home.activation.opencodeConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
        target="${config.home.homeDirectory}/.config/opencode/opencode.jsonc"
        run mkdir -p "$(dirname "$target")"
        if [ -f "${identityPath}" ]; then
          webhook_url="$(${pkgs.age}/bin/age -d -i "${identityPath}" "${secretFile}")"
          ${pkgs.gnused}/bin/sed "s|__HA_WEBHOOK_URL__|$webhook_url|" "${templateFile}" > "$target.tmp"
          run mv "$target.tmp" "$target"
          run chmod 600 "$target"
        else
          warnEcho "[opencode] ${identityPath} not found; leaving $target untouched. Decrypt manually with: age -d -i <identity> ${secretFile}, then rerun the home-manager switch."
        fi
      '';
    })
  ];
}
