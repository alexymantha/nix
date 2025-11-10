{ pkgs, lib, ... }:

let
  username = "amantha";
  
  # Seamless login C program
  seamlessLoginSrc = pkgs.writeText "seamless-login.c" ''
    /*
    * Seamless Login - Minimal SDDM-style Plymouth transition
    * Replicates SDDM's VT management for seamless auto-login
    */
    #include <stdio.h>
    #include <stdlib.h>
    #include <unistd.h>
    #include <fcntl.h>
    #include <sys/ioctl.h>
    #include <linux/kd.h>
    #include <linux/vt.h>
    #include <sys/wait.h>
    #include <string.h>

    int main(int argc, char *argv[]) {
        int vt_fd;
        int vt_num = 1; // TTY1
        char vt_path[32];
        
        if (argc < 2) {
            fprintf(stderr, "Usage: %s <session_command>\n", argv[0]);
            return 1;
        }
        
        // Open the VT (simple approach like SDDM)
        snprintf(vt_path, sizeof(vt_path), "/dev/tty%d", vt_num);
        vt_fd = open(vt_path, O_RDWR);
        if (vt_fd < 0) {
            perror("Failed to open VT");
            return 1;
        }
        
        // Activate the VT
        if (ioctl(vt_fd, VT_ACTIVATE, vt_num) < 0) {
            perror("VT_ACTIVATE failed");
            close(vt_fd);
            return 1;
        }
        
        // Wait for VT to be active
        if (ioctl(vt_fd, VT_WAITACTIVE, vt_num) < 0) {
            perror("VT_WAITACTIVE failed");
            close(vt_fd);
            return 1;
        }
        
        // Critical: Set graphics mode to prevent console text
        if (ioctl(vt_fd, KDSETMODE, KD_GRAPHICS) < 0) {
            perror("KDSETMODE KD_GRAPHICS failed");
            close(vt_fd);
            return 1;
        }
        
        // Clear VT and close (like SDDM does)
        const char *clear_seq = "\33[H\33[2J";
        if (write(vt_fd, clear_seq, strlen(clear_seq)) < 0) {
            perror("Failed to clear VT");
        }
        
        close(vt_fd);
        
        // Set working directory to user's home
        const char *home = getenv("HOME");
        if (home) chdir(home);
        
        // Now execute the session command
        execvp(argv[1], &argv[1]);
        perror("Failed to exec session");
        return 1;
    }
  '';

  seamlessLogin = pkgs.stdenv.mkDerivation {
    name = "seamless-login";
    src = seamlessLoginSrc;
    dontUnpack = true;
    buildInputs = [ pkgs.gcc ];
    buildPhase = ''
      gcc -o seamless-login ${seamlessLoginSrc}
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp seamless-login $out/bin/
      chmod +x $out/bin/seamless-login
    '';
  };

  omarchy-plymouth = pkgs.stdenv.mkDerivation {
    name = "omarchy-plymouth";
    src = pkgs.fetchFromGitHub {
      owner = "basecamp";
      repo = "omarchy";
      rev = "v3.0.2";
      sha256 = "sha256-1QJBoMe6MzaD/dcOcqC8QpRxG0Z2c1p+WYqtNFlsTOA=";
    };
    
    installPhase = ''
        mkdir -p $out/share/plymouth/themes/omarchy
        if [ -d "default/plymouth" ]; then
          cp -r default/plymouth/* $out/share/plymouth/themes/omarchy/
          find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
        else
          echo "Error: Directory default/plymouth not found in repository"
          exit 1
        fi
    '';
  };
in {
  boot.plymouth = {
    enable = true;
    theme = "omarchy";
    themePackages = [omarchy-plymouth];
  };

  boot = {
    # Silent boot
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    loader.timeout = 0;
  };

  systemd.services.omarchy-seamless-login = {
    description = "Omarchy Seamless Auto-Login";
    documentation = [ "https://github.com/basecamp/omarchy" ];
    
    after = [ 
      "systemd-user-sessions.service"
      "getty@tty1.service"
      "plymouth-quit.service"
      "systemd-logind.service"
    ];
    
    conflicts = [ "getty@tty1.service" ];
    partOf = [ "graphical.target" ];
    wantedBy = [ "graphical.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${seamlessLogin}/bin/seamless-login uwsm start -- hyprland-uwsm.desktop";
      Restart = "always";
      RestartSec = 2;
      StartLimitIntervalSec = 30;
      StartLimitBurst = 2;
      User = username;
      TTYPath = "/dev/tty1";
      TTYReset = "yes";
      TTYVHangup = "yes";
      TTYVTDisallocate = "yes";
      StandardInput = "tty";
      StandardOutput = "journal";
      StandardError = "journal+console";
      PAMName = "login";
    };
  };

  # ==============================================================================
  # PLYMOUTH AND GETTY ADJUSTMENTS
  # ==============================================================================

  # Make plymouth remain until graphical.target
  systemd.services.plymouth-quit = {
    serviceConfig = {
      After = lib.mkForce [ "multi-user.target" ];
    };
  };

  # Mask plymouth-quit-wait service
  systemd.services.plymouth-quit-wait.enable = false;

  # Disable getty on tty1 since we're using it for auto-login
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
