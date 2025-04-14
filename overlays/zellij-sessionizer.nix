{
inputs,
...
}: {
  additions = final: _prev: {
    # Based on zjstatus flake.nix
    zellij-sessionizer = 
      let 
        rustWithWasiTarget = final.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-std" "rust-analyzer" ];
          targets = [ "wasm32-wasip1" ];
        };
        craneLib = (inputs.crane.mkLib final).overrideToolchain rustWithWasiTarget;
      in
        craneLib.buildPackage {
          src = final.fetchFromGitHub {
            owner = "laperlej";
            repo = "zellij-sessionizer";
            rev = "v0.4.3";
            sha256 = "sha256-G2O77M+0ua53WpoNBkE3sNp3yN7uv9byqIteSyEluiQ=";
          };
          cargoExtraArgs = "--target wasm32-wasip1";
          # Tests currently need to be run via cargo wasi which
          # isn't packaged in nixfinal yet...
          doCheck = false;
          doNotSign = true;
          buildInputs = [
            # Add additional build inputs here
            final.libiconv
          ];
        };
  };
}
