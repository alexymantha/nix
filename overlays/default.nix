{inputs, ...}: 
let
  zellij-sessionizer = import ./zellij-sessionizer.nix {inherit inputs;};
in
{
  additions = final: prev: {
    zjstatus = inputs.zjstatus.packages.${final.system}.default;
    zig = inputs.zig.packages.${final.system}.master-2024-12-30;
    zls = inputs.zls.packages.${final.system}.default;
  } // (zellij-sessionizer.additions final prev);

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # zig = (prev.zig.override {
    #   llvmPackages = prev.llvmPackages_19;
    # }).overrideAttrs (oldAttrs: {
    #     version = "0.14.0-dev.3026+c225b780e";
    #     src = prev.fetchFromGitHub {
    #       owner = "ziglang";
    #       repo = "zig";
    #       rev = "c225b780e";
    #       hash = "sha256-s4hJjEZcj/iSEa+dlxS1Pesc62c4/w6W88qq5uTUP9A=";
    #     };
    # });
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
    };
  };
}
