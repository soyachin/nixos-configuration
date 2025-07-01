{
  description = "NixOS configuration with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Add unstable channel
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, sops-nix, ... }@inputs: 
    let
      system = "x86_64-linux"; 
      pkgs = nixpkgs.legacyPackages.${system};
      unstable = import nixpkgs-unstable { 
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs unstable; }; 

        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops

          {
            home-manager = {
              extraSpecialArgs = { inherit inputs unstable; }; 
              users.hojas = import ./home/main-user.nix;
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [inputs.sops-nix.homeManagerModules.sops];
            };
          }
        ];
      };

      devShells.${system}.default = pkgs.mkShell {
        name = "nix-config-dev";
        buildInputs = with pkgs; [
          nil
          alejandra
          git
          nix-index
        ];

        shellHook = ''
          echo "Entorno de desarrollo de Nix listo."
          export NIX_LSP_FORMATTER=alejandra
        '';
      };
    };
}