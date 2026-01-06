{
  inputs,
  outputs,
  pkgs,
  lib,
  config,
  darwin,
  ...
}:
let
  yubikey-agent = pkgs.buildGoModule rec {
    pname = "yubikey-agent";
    version = "0.2.0";

    vendorHash = "sha256-IGnaeOZhrUeysYNcjPVADE1UyEgqVPD2G0qOCtl4zSM=";

    src = pkgs.fetchFromGitHub {
      owner = "alexymantha";
      repo = "yubikey-agent";
      rev = "v${version}";
      hash = "sha256-SYG/za3vNFq7IVQffUWxHVrmqwrXKjp07xRg5GtmyAM=";
    };

    buildInputs =
      lib.optional pkgs.stdenv.hostPlatform.isLinux (lib.getDev pkgs.pcsclite)
      ++ lib.optional pkgs.stdenv.hostPlatform.isDarwin (darwin.apple_sdk.frameworks.PCSC);

    nativeBuildInputs = lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.pkg-config ];

    postPatch = lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
      substituteInPlace main.go --replace 'notify-send' ${pkgs.libnotify}/bin/notify-send
    '';

    doCheck = false;

    subPackages = [ "." ];

    ldflags = [
      "-s"
      "-w"
      "-X main.Version=${version}"
    ];
  };
in
{
  environment.systemPackages = [ yubikey-agent ];
  systemd.packages = [ yubikey-agent ];

  systemd.user.services.yubikey-agent = lib.mkForce {
    description = "Seamless ssh-agent for YubiKeys";
    documentation = [ "https://filippo.io/yubikey-agent" ];
    wantedBy = [ "default.target" ];
    path = [ pkgs.pinentry-all ];

    serviceConfig = {
      ExecStart = "${yubikey-agent}/bin/yubikey-agent -l %t/yubikey-agent/yubikey-agent.sock -slots 0x9a,0x9c,0x95";
      ExecReload = "/bin/kill -HUP $MAINPID";
      IPAddressDeny = "any";
      RestrictAddressFamilies = "AF_UNIX";
      RestrictNamespaces = "yes";
      RestrictRealtime = "yes";
      RestrictSUIDSGID = "yes";
      LockPersonality = "yes";
      SystemCallFilter = "@system-service ~@privileged @resources";
      SystemCallErrorNumber = "EPERM";
      SystemCallArchitectures = "native";
      NoNewPrivileges = "yes";
      KeyringMode = "private";
      UMask = "0177";
      RuntimeDirectory = "yubikey-agent";
    };
  };

  # Yubikey-agent expects pcsd to be running in order to function.
  services.pcscd.enable = true;

  environment.extraInit = ''
    if [ -z "$SSH_AUTH_SOCK" -a -n "$XDG_RUNTIME_DIR" ]; then
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock"
    fi
  '';
}
