{
  description = "NixOS configuration with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    sops-nix = {
      url = "github:Mic92/sops-nix";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }@inputs:

    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

    in {

        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
            specialArgs = {inherit inputs;};

            modules = [
                ./configuration.nix
                inputs.home-manager.nixosModules.home-manager
                sops-nix.nixosModules.sops

                {

                  home-manager = {
                    extraSpecialArgs = {inherit inputs;};
                    users.hojas = import ./home/main-user.nix;
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    sharedModules = [inputs.sops-nix.homeManagerModules.sops ];
                  };

                }
            ];
        };

    };

  }
