{
  inputs,
  outputs,
  pkgs,
  lib,
  config,
  ...
}: let
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
      ++ lib.optional pkgs.stdenv.hostPlatform.isDarwin (pkgs.darwin.apple_sdk.frameworks.PCSC);

    nativeBuildInputs = lib.optionals pkgs.stdenv.hostPlatform.isLinux [pkgs.pkg-config];

    postPatch = lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
      substituteInPlace main.go --replace 'notify-send' ${pkgs.libnotify}/bin/notify-send
    '';

    doCheck = false;

    subPackages = ["."];

    ldflags = [
      "-s"
      "-w"
      "-X main.Version=${version}"
    ];
  };
  homeDir = "/Users/${config.users.users.amantha.name}";
in {
  environment.systemPackages = [yubikey-agent];
  # systemd.packages = [ yubikey-agent ];

  launchd.user.agents.yubikey-agent = {
    serviceConfig = {
      Label = "io.filippo.yubikey-agent";
      ProgramArguments = [
        "${yubikey-agent}/bin/yubikey-agent"
        "-l"
        "${homeDir}/.yubikey-agent/yubikey-agent.sock"
        "-slots"
        "0x9a,0x9c,0x95"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${homeDir}/Library/Logs/yubikey-agent.log";
      StandardErrorPath = "${homeDir}/Library/Logs/yubikey-agent-error.log";
      # Create the runtime directory
      WorkingDirectory = "${homeDir}/.yubikey-agent";
    };
  };

  # Ensure the directory exists
  system.activationScripts.preActivation.text = ''
    mkdir -p "${homeDir}/.yubikey-agent"
    chown amantha:staff "${homeDir}/.yubikey-agent"
  '';

  environment.extraInit = ''
    export SSH_AUTH_SOCK="${homeDir}/.yubikey-agent/yubikey-agent.sock"
  '';
}
