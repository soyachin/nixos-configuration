{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;

  mkSystem =
    {
      hostname,
      system ? "x86_64-linux",
      isHeadless ? false,
      extraModules ? [ ],
      urbaniaPkg ? inputs.urbania,
    }:
    let
      unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          unstable
          hostname
          isHeadless
          urbaniaPkg
          ;
      };
      modules = [
        { nixpkgs.hostPlatform = system; }
        ./${hostname}/default.nix
        inputs.sops-nix.nixosModules.sops
      ]
      ++ extraModules;
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
    extraModules = [
      inputs.trama.nixosModules.default
    ];
  };

  mini-test = mkSystem {
    hostname = "mini";
    isHeadless = true;
    urbaniaPkg = inputs.urbania-test;
    extraModules = [
      inputs.trama.nixosModules.default
    ];
  };
}
