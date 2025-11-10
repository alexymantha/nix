{
...
}: {
  services.walker.enable = true;
  home.file.".config/walker/themes/default.toml"= {
    source = ./default.toml;
    force = true;
  };
  home.file.".config/walker/themes/default.css" = {
    source = ./default.css;
    force = true;
  };

  services.walker.settings = {
    close_when_open = true;
    theme = "default";
    theme_base = [];
    theme_location = ["~/.config/walker/themes/"];
    hotreload_theme = true;
    force_keyboard_focus = true;
    timeout = 60;

    list = {
      max_entries = 200;
      cycle = true;
    };

    search = {
      placeholder = " Search...";
    };

    builtins = {
      hyprland_keybinds = {
        path = "~/.config/hypr/hyprland.conf";
        hidden = true;
      };

      applications = {
        launch_prefix = "uwsm app -- ";
        placeholder = " Search...";
        prioritize_new = false;
        context_aware = false;
        show_sub_when_single = false;
        history = false;
        icon = "";
        hidden = true;

        actions = {
          enabled = false;
          hide_category = true;
        };
      };

      calc = {
        name = "Calculator";
        icon = "";
        min_chars = 3;
        prefix = "=";
      };

      windows = {
        switcher_only = true;
        hidden = true;
      };

      clipboard = {
        hidden = true;
      };

      commands = {
        hidden = true;
      };

      custom_commands = {
        hidden = true;
      };

      emojis = {
        name = "Emojis";
        icon = "";
        prefix = ":";
      };

      symbols = {
        after_copy = "";
        hidden = true;
      };

      finder = {
        use_fd = true;
        cmd_alt = "xdg-open $(dirname ~/%RESULT%)";
        icon = "file";
        name = "Finder";
        preview_images = true;
        hidden = false;
        prefix = ".";
      };

      runner = {
        shell_config = "";
        switcher_only = true;
        hidden = true;
      };

      ssh = {
        hidden = true;
      };

      websearch = {
        switcher_only = true;
        hidden = true;
      };

      translation = {
        hidden = true;
      };
    };
  };
}
