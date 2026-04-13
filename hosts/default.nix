{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;

  # Helper para crear sistemas de forma limpia
  mkSystem = { hostname, system ? "x86_64-linux", extraModules ? [ ] }:
    let
      unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs unstable hostname; };
      modules = [
        { nixpkgs.hostPlatform = system; }
        ../common/default.nix
        ./${hostname}/configuration.nix
        inputs.sops-nix.nixosModules.sops
      ] ++ extraModules;
    };
in
{
  # --- ASUS (Desktop) ---
  asus = mkSystem {
    hostname = "asus";
  };

  # --- MINI (Server) ---
  mini = mkSystem {
    hostname = "mini";
  };
}
