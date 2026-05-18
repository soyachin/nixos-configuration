{ config, pkgs, ... }:
let
  # Override file loaded AFTER the sops env file so these values
  # always win, even if vaultwarden_env contains the same keys.
  registrationOverrides = pkgs.writeText "vaultwarden-registration.env" ''
    SIGNUPS_ALLOWED=true
    INVITATIONS_ALLOWED=true
    SIGNUPS_VERIFY=false
  '';
in
{
  sops.secrets."vaultwarden_env" = { };

  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    config = {
      DOMAIN = "https://vault.nyarkovchain.site";
      SIGNUPS_ALLOWED = true;
      INVITATIONS_ALLOWED = true;
      SIGNUPS_VERIFY = false;
      SHOW_PASSWORD_HINT = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
    };
    environmentFile = [
      config.sops.secrets.vaultwarden_env.path
      registrationOverrides
    ];
  };

  systemd.services.vaultwarden.after = [ "sops-nix.service" ];
}
