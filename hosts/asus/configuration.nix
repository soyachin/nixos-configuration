{
  inputs,
  unstable,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./modules
    ./programs
    inputs.noctalia.nixosModules.default
    inputs.aagl.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];

  networking.hostName = "asus";

  # --- AAGL ---
  nix.settings = inputs.aagl.nixConfig;
  programs.anime-game-launcher.enable = true;
  programs.anime-games-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;

  # --- HOME MANAGER ---
  home-manager = {
    extraSpecialArgs = { inherit inputs unstable; };
    users.hojas = import ./home/main-user.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  system.stateVersion = "24.11";
}
