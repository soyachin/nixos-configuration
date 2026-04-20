{
  description = "NixOS configuration with Home Manager and Multi-host";

  inputs = {
    # --- CORE ---
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    # --- DESKTOP ONLY ---
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    quickshell.url = "github:outfoxxed/quickshell";
    quickshell.inputs.nixpkgs.follows = "nixpkgs";

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "github:fufexan/nix-gaming";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix/release-25.11";
    aagl.inputs.nixpkgs.follows =
      "nixpkgs"; # Name of nixpkgs input you want to use
    
    nixvim.url = "github:nix-community/nixvim/nixos-25.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      flake.nixosConfigurations = import ./hosts { inherit inputs; };

      perSystem =
        { pkgs, system, ... }:
        let
          unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          devShells.default = pkgs.mkShell {
            name = "nix-config-dev";
            buildInputs = with pkgs; [
              nil
              alejandra
              git
              nix-index
              unstable.sops
            ];
            shellHook = ''
              echo "Entorno de desarrollo de Nix listo."
              export NIX_LSP_FORMATTER=alejandra
            '';
          };
        };
    };
}
