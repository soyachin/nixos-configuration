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
    # noctalia.inputs.quickshell.follows = "quickshell";

    nix-gaming.url = "github:fufexan/nix-gaming";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix/release-25.11";
    # Or, if you follow Nixkgs release 25.05:
    # aagl.url = "github:ezKEa/aagl-gtk-on-nix/release-25.05";
    aagl.inputs.nixpkgs.follows =
      "nixpkgs"; # Name of nixpkgs input you want to use
    
     mistral-vibe.url = "github:pitaya1219/mistral-vibe-nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, sops-nix, aagl, mistral-vibe, ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};

      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      # CORE: Lo que TODOS los hosts necesitan (incluso el server)
      baseInputs = { inherit (inputs) nixpkgs nixpkgs-unstable sops-nix self; };

      # Inputs Desktop: Base + Gráficos + Home Manager + Temas
      desktopInputs = baseInputs // {
        inherit (inputs) home-manager quickshell noctalia nix-gaming aagl mistral-vibe;
      };

      # mkSystem
      # Recibe: hostname, el grupo de inputs correcto, y módulos extra
      mkSystem = { hostname, inputGroup, extraModules ? [ ], }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          # inputs filtrados y 'unstable' a todos los módulos
          specialArgs = {
            inputs = inputGroup;
            inherit unstable hostname;
          };

          modules = [
            # A. Configuración Común (SSH, Locale, Nix settings)
            ./common/default.nix

            # B. Configuración del Host específico
            ./hosts/${hostname}/configuration.nix

            # C. Módulos globales esenciales (como sops)
            sops-nix.nixosModules.sops
          ] ++ extraModules; # D. Módulos extra pasados como argumento
        };
    in {
      nixosConfigurations = {
        # --- ASUS (Desktop) ---
        # Usa desktopInputs y carga Home Manager
        asus = mkSystem {
          hostname = "asus";
          inputGroup = desktopInputs;
          extraModules = [
            inputs.aagl.nixosModules.default
            {
              nix.settings = inputs.aagl.nixConfig;

              programs.anime-game-launcher.enable = true;
              programs.anime-games-launcher.enable = true;
              programs.honkers-railway-launcher.enable = true;
            }
            inputs.home-manager.nixosModules.home-manager

            {
              home-manager = {
                # Importante: pasar los inputs al propio Home Manager
                extraSpecialArgs = {
                  inputs = desktopInputs;
                  inherit unstable;
                };
                users.hojas = import ./hosts/asus/home/main-user.nix;

                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bak";
                sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
              };
            }
          ];
        };

        # --- MINI (Server) ---
        # Usa baseInputs y NO carga Home Manager ni cosas gráficas
        mini = mkSystem {
          hostname = "mini";
          inputGroup = baseInputs;

          # Sin módulos extra
          extraModules = [ ];
        };
      };

      # Shell de desarrollo
      devShells.${system}.default = pkgs.mkShell {
        name = "nix-config-dev";
        buildInputs = with pkgs; [ nil alejandra git nix-index ];
        shellHook = ''
          echo "Entorno de desarrollo de Nix listo."
          export NIX_LSP_FORMATTER=alejandra
        '';
      };
    };
}
