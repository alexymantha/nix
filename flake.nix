{
  description = "Nix configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Nix Darwin
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Agenix
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    zig.url = "github:alexymantha/zig-overlay";
    zls.url = "github:zigtools/zls?ref=0.14.0";
    zjstatus.url = "github:dj95/zjstatus";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    crane.url = "github:ipetkov/crane";
  };

  outputs = {
    self,
    crane,
    darwin,
    home-manager,
    nixpkgs,
    nixpkgs-unstable,
    nur,
    rust-overlay,
    zig,
    zjstatus,
    zls,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    overlays = import ./overlays {inherit inputs;};

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      amantha-nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          {nix.channel.enable = false;}
          {nixpkgs.overlays = [
              nur.overlays.default
              rust-overlay.overlays.default
            ];}
          # > Our main nixos configuration file <
          ./hosts/nixos/configuration.nix
        ];
      };
    };

    # Darwin configuration entrypoint
    darwinConfigurations = {
      # Personal laptop
      amantha-air = darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        stdenv.hostPlatform.system = "aarch64-darwin";
        modules = [
          {nix.channel.enable = false;}
          {nixpkgs.overlays = [
              nur.overlays.default
              rust-overlay.overlays.default
            ];}
          ./hosts/darwin/default.nix
          ./hosts/darwin/amantha-air/overrides.nix
        ];
      };
      # Work laptop
      amantha-mbp = darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        stdenv.hostPlatform.system = "aarch64-darwin";
        modules = [
          {nix.channel.enable = false;}
          {nixpkgs.overlays = [
              nur.overlays.default
              rust-overlay.overlays.default
            ];}
          ./hosts/darwin/default.nix
          ./hosts/darwin/amantha-mbp/overrides.nix
        ];
      };
    };
  };
}
