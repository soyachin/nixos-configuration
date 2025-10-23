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

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell"; # Use same quickshell version
    };

    base16.url = "github:SenchoPens/base16.nix";

    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

    base16-zathura = {
      url = "github:haozeke/base16-zathura";
      flake = false;
    };

    base16-vim = {
      url = "github:tinted-theming/base16-vim";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    sops-nix,
    quickshell,
    noctalia,
    base16,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.asus = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs unstable;};

      modules = [
        ./configuration.nix

        inputs.home-manager.nixosModules.home-manager
        sops-nix.nixosModules.sops

        {
          home-manager = {
            extraSpecialArgs = {inherit inputs unstable;};
            users.hojas = import ./home/main-user.nix;
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
            ];
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
