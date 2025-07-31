{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    # Will use the package from the NixOS module
    package = pkgs.hyprland;
    # portalPackage = null;

    settings = {
      monitor = ",preferred,auto,auto";

      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$menu" = "fuzzel";
      "$mainMod" = "SUPER";

      exec-once = [
        "$terminal"
        "nm-applet &"
        "waybar"
        "hyprpaper"
      ];

      env = [
        "HYPRCURSOR_THEME,NotwaitaBlack"
        "XCURSOR_THEME,NotwaitaBlack"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      general = {
        gaps_in = 6;
        gaps_out = 6;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 4;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        blur = {
          enabled = true;
          xray = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = true;
        font_family = "JetBrainsMono Nerd Font";
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        accel_profile = "flat";
        touchpad = {
          natural_scroll = false;
        };
      };

      gestures = {
        workspace_swipe = false;
      };

      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod SHIFT, Q, killactive,"
        "$mainMod, M, exit,"
        # "$mainMod, V, togglefloating," # Conflicts with muscle memory for Cmd+V to paste, let's find another keybind
        "$mainMod, Space, exec, $menu"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Screenshot with grim and slurp
        "$mainMod SHIFT, s, exec, grim -g \"$(slurp -d)\" - | wl-copy"
      ];

      bindel = [
        # Volume control
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        # Brightness control
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        # Media controls
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "opacity 0.0 override, class:^(xwaylandvideobridge)$"
        "noanim, class:^(xwaylandvideobridge)$"
        "noinitialfocus, class:^(xwaylandvideobridge)$"
        "maxsize 1 1, class:^(xwaylandvideobridge)$"
        "noblur, class:^(xwaylandvideobridge)$"
      ];
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

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = "${./wallpaper.png}";
      wallpaper = ", ${./wallpaper.png}";
    };
  };

  # TODO: Use home-manager options when available
  # It's currently only in unstable
  systemd.user.services.hyprpolkitagent = {
    Unit = {
      Description = "Hyprland PolicyKit Agent";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };

    Install = {WantedBy = ["graphical-session.target"];};

    Service = {ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";};
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
