{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
     package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
     portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    settings = {
      source = "~/.config/hypr/amantha.conf";
    };
  };
  programs.waybar.enable = true;
  # From https://github.com/catppuccin/fuzzel/blob/main/themes/macchiato/red.ini
  home.file.".config/fuzzel/themes/macchiato/red.ini".text = ''
    [colors]
    background=24273add
    text=cad3f5ff
    match=ed8796ff
    selection=5b6078ff
    selection-match=ed8796ff
    selection-text=cad3f5ff
    border=b7bdf8ff
  '';
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        include = "${config.xdg.configHome}/fuzzel/themes/macchiato/red.ini";
        dpi-aware = true;
        font = "JetBrainsMono Nerd Font:size=24";
      };
    };
  };

  programs.hyprlock.enable = true;
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        before_sleep_cmd = "loginctl lock-session";
        lock_cmd = "pidof hyprlock || hyprlock";
      };
      listener = [
        {
          on-timeout = "loginctl lock-session";
          timeout = 300;
        }
        {
          on-resume = "hyprctl dispatch dpms on";
          on-timeout = "hyprctl dispatch dpms off";
          timeout = 330;
        }
        {
          on-timeout = "systemctl suspend";
          timeout = 1800;
        }
      ];
    };
  };
  home.file.".config/hypr/images/cat-line.png".source = ./cat-line.png;
  home.file.".config/hypr/hyprlock.conf".text = ''
    source = $HOME/.config/hypr/macchiato.conf

    $accent = $red
    $accentAlpha = $redAlpha
    $font = JetBrainsMono Nerd Font

    # GENERAL
    general {
      disable_loading_bar = true
      hide_cursor = true
    }

    # BACKGROUND
    background {
      monitor =
      blur_passes = 0
      path = $HOME/.config/hypr/images/cat-line.png
      color = $base
    }

    # TIME
    label {
      monitor =
      text = $TIME
      color = $text
      font_size = 90
      font_family = $font
      position = -30, 0
      halign = right
      valign = top
    }

    # DATE
    label {
      monitor =
      text = cmd[update:43200000] date +"%A, %d %B %Y"
      color = $text
      font_size = 25
      font_family = $font
      position = -30, -150
      halign = right
      valign = top
    }

    # INPUT FIELD
    input-field {
      monitor =
      size = 300, 60
      outline_thickness = 4
      dots_size = 0.2
      dots_spacing = 0.2
      dots_center = true
      outer_color = $accent
      inner_color = $surface0
      font_color = $text
      fade_on_empty = false
      placeholder_text = <span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>
      hide_input = false
      check_color = $accent
      fail_color = $red
      fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
      capslock_color = $yellow
      position = 0, -47
      halign = center
      valign = center
    }
  '';
  home.file.".config/hypr/macchiato.conf".text = ''
    $rosewater = rgb(f4dbd6)
    $rosewaterAlpha = f4dbd6

    $flamingo = rgb(f0c6c6)
    $flamingoAlpha = f0c6c6

    $pink = rgb(f5bde6)
    $pinkAlpha = f5bde6

    $mauve = rgb(c6a0f6)
    $mauveAlpha = c6a0f6

    $red = rgb(ed8796)
    $redAlpha = ed8796

    $maroon = rgb(ee99a0)
    $maroonAlpha = ee99a0

    $peach = rgb(f5a97f)
    $peachAlpha = f5a97f

    $yellow = rgb(eed49f)
    $yellowAlpha = eed49f

    $green = rgb(a6da95)
    $greenAlpha = a6da95

    $teal = rgb(8bd5ca)
    $tealAlpha = 8bd5ca

    $sky = rgb(91d7e3)
    $skyAlpha = 91d7e3

    $sapphire = rgb(7dc4e4)
    $sapphireAlpha = 7dc4e4

    $blue = rgb(8aadf4)
    $blueAlpha = 8aadf4

    $lavender = rgb(b7bdf8)
    $lavenderAlpha = b7bdf8

    $text = rgb(cad3f5)
    $textAlpha = cad3f5

    $subtext1 = rgb(b8c0e0)
    $subtext1Alpha = b8c0e0

    $subtext0 = rgb(a5adcb)
    $subtext0Alpha = a5adcb

    $overlay2 = rgb(939ab7)
    $overlay2Alpha = 939ab7

    $overlay1 = rgb(8087a2)
    $overlay1Alpha = 8087a2

    $overlay0 = rgb(6e738d)
    $overlay0Alpha = 6e738d

    $surface2 = rgb(5b6078)
    $surface2Alpha = 5b6078

    $surface1 = rgb(494d64)
    $surface1Alpha = 494d64

    $surface0 = rgb(363a4f)
    $surface0Alpha = 363a4f

    $base = rgb(24273a)
    $baseAlpha = 24273a

    $mantle = rgb(1e2030)
    $mantleAlpha = 1e2030

    $crust = rgb(181926)
    $crustAlpha = 181926
  '';
}
