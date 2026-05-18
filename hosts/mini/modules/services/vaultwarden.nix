{ config, ... }:
{
  sops.secrets."vaultwarden_env" = {};

  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    config = {
      DOMAIN = "https://vault.nyarkovchain.site";
      SIGNUPS_ALLOWED = true;
      INVITATIONS_ALLOWED = true;
      SHOW_PASSWORD_HINT = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
    };
    environmentFile = config.sops.secrets.vaultwarden_env.path;
  };

  systemd.services.vaultwarden.after = ["sops-nix.service"];
}
