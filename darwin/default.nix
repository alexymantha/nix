{ pkgs, ... }:
{
    # Make sure the nix daemon always runs
    services.nix-daemon.enable = true;
    nix = {
        package = pkgs.nix;
        settings.experimental-features = [ "nix-command" "flakes" ];
    };

    programs.zsh.enable = true;
    homebrew = {
        enable = true;
        onActivation = {
            autoUpdate = true;
            upgrade = true;
        };
        # updates homebrew packages on activation,
        # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
        casks = [
            "cf-keylayout"
            "cloudflare-warp"
            "discord"
            "gimp"
            "obs"
            "slack"
            "vlc"
            "wezterm"
        ];
    };
}
