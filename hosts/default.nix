{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;

  mkSystem = { hostname, system ? "x86_64-linux", isHeadless ? false, extraModules ? [ ] }:
    let
      unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    lib.nixosSystem {
      specialArgs = { inherit inputs unstable hostname isHeadless; };
      modules = [
        { nixpkgs.hostPlatform = system; }
        ./${hostname}/default.nix
        inputs.sops-nix.nixosModules.sops
      ] ++ extraModules;
    };

  desktopModules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.noctalia.nixosModules.default
    inputs.aagl.nixosModules.default
  ];
in
{
  asus = mkSystem {
    hostname = "asus";
    extraModules = desktopModules;
  };

  mini = mkSystem {
    hostname = "mini";
    isHeadless = true;
  };
}
