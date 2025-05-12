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
  modifications = final: prev: {};

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
    };
  };
}
