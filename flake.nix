{
  description = "Nix configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.
    
    # Nix Darwin
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    darwin,
    nur,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "x86_64-linux"
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
          { nixpkgs.overlays = [ nur.overlay ]; }
          # > Our main nixos configuration file <
          ./hosts/nixos/configuration.nix
        ];
      };
    };

    # Darwin configuration entrypoint
    darwinConfigurations = {
      # Personal laptop
      amantha-air = darwin.lib.darwinSystem {
	specialArgs = { inherit inputs outputs; };
        system = "aarch64-darwin";
        modules = [
          { nixpkgs.overlays = [ nur.overlay ]; }
          ./hosts/darwin/default.nix 
          ./hosts/darwin/amantha-air/overrides.nix
        ];
      };
      # Work laptop
      amantha-mbp = darwin.lib.darwinSystem {
	specialArgs = { inherit inputs outputs; };
        system = "aarch64-darwin";
        modules = [
          { nixpkgs.overlays = [ nur.overlay ]; }
          ./hosts/darwin/default.nix 
          ./hosts/darwin/amantha-mbp/overrides.nix
        ];
      };
    };
  };
}
