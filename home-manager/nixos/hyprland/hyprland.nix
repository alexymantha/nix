{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./autostart.nix
    ./envs.nix
    ./hypridle.nix
    ./input.nix
    ./looknfeel.nix
    ./windows.nix
    ./mako.nix
    ./swayosd.nix
    ./walker/walker.nix
    ./waybar/waybar.nix
  ];

  home.packages = with pkgs; [
    hypridle
    hyprpicker
    hyprshot
    hyprsunset
    nautilus
    blueberry
    wl-clip-persist
    wl-clipboard
    wl-screenrec
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    # Will use the package from the NixOS module
    package = pkgs.hyprland;

    settings = {
      monitor = ",preferred,auto,auto";

      "$mainMod" = "SUPER";
      "$browser" = "uwsm app -- brave";
      "$terminal" = "uwsm app -- ghostty";
      "$menu" = "uwsm app -- walker";

      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod, B, exec, $browser"
        "$mainMod SHIFT, B, exec, $browser --private"
        "$mainMod, F, exec, uwsm app -- nautilus --new-window"
        "$mainMod, M, exec, omarchy-launch-or-focus spotify"
        "$mainMod SHIFT, Q, killactive,"
        "$mainMod, M, exec, uwsm stop"
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
        ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ",XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ",XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"

        # Brightness control
        ",XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
        ",XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
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
    };
  };

  # TODO: Use home-manager options when available
  # It's currently only in unstable
  # systemd.user.services.hyprpolkitagent = {
  #   Unit = {
  #     Description = "Hyprland PolicyKit Agent";
  #     After = ["graphical-session-pre.target"];
  #     PartOf = ["graphical-session.target"];
  #   };

  #   Install = {WantedBy = ["graphical-session.target"];};

  #   Service = {ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";};
  # };
}
