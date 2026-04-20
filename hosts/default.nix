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
      specialArgs = { inherit inputs unstable hostname; };
      modules = [
        { nixpkgs.hostPlatform = system; }
        ../common/default.nix
        ./${hostname}/configuration.nix
        inputs.sops-nix.nixosModules.sops
      ] ++ extraModules;
    };

  desktopModules = [
    ../common/desktop.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.noctalia.nixosModules.default
    inputs.aagl.nixosModules.default
  ];
in
{
  # --- ASUS (Desktop) ---
  asus = mkSystem {
    hostname = "asus";
    extraModules = desktopModules;
  };

  # --- MINI (Server) ---
  mini = mkSystem {
    hostname = "mini";
  };
}
