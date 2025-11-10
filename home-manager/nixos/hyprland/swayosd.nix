{
  ...
}: {
  services.swayosd.enable = true;

  home.file.".config/swayosd/config.toml".text = ''
    [server]
    show_percentage = true
    max_volume = 100
    style = "./style.css"
  '';
  home.file.".config/swayosd/style.css".text = ''
    @define-color background-color #24273a;
    @define-color border-color #c6d0f5;
    @define-color label #cad3f5;
    @define-color image #cad3f5;
    @define-color progress #cad3f5;

    window {
      border-radius: 0;
      opacity: 0.97;
      border: 2px solid @border-color;

      background-color: @background-color;
    }

    label {
      font-family: 'JetBrainsMono Nerd Font';
      font-size: 11pt;

      color: @label;
    }

    image {
      color: @image;
    }

    progressbar {
      border-radius: 0;
    }

    progress {
      background-color: @progress;
    }
    '';
}
