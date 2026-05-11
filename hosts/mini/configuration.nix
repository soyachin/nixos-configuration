# hosts/mini/configuration.nix
{ config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./users.nix
    ./modules
  ];

  networking.hostName = "mini";

  sops.secrets.tailscale_mini_key = { owner = "root"; };

  # ─── Urbania BI ──────────────────────────────────────────────────────────
  services.urbania = {
    enable   = true;
    dataDir  = "/var/lib/urbania";
    repoPath = "/var/lib/urbania/repo";
  };

  system.stateVersion = "25.05";
}
