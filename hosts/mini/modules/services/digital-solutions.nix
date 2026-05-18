# hosts/mini/modules/services/digital-solutions.nix
{ config, lib, ... }:
let
  domain = "nyarkovchain.site";
in
{
  # --- sops secrets ---
  sops.secrets."stack/odoo/db_password" = {};
  sops.secrets."stack/odoo/smtp_user" = {};
  sops.secrets."stack/odoo/smtp_password" = {};
  sops.secrets."stack/n8n/db_password" = {};
  sops.secrets."stack/n8n/encryption_key" = {};
  sops.secrets."stack/evolution/api_key" = {};
  sops.secrets."stack/evolution/mongo_password" = {};
  sops.secrets."stack/postiz/db_password" = {};
  sops.secrets."stack/postiz/secret" = {};

  # --- sops templates (environment files) ---
  sops.templates."stack-odoo-env" = {
    content = ''
      DB_PASSWORD=${config.sops.placeholder."stack/odoo/db_password"}
      SMTP_USER=${config.sops.placeholder."stack/odoo/smtp_user"}
      SMTP_PASSWORD=${config.sops.placeholder."stack/odoo/smtp_password"}
    '';
    owner = "odoo";
  };

  sops.templates."stack-n8n-env" = {
    content = ''
      DB_POSTGRESDB_PASSWORD=${config.sops.placeholder."stack/n8n/db_password"}
      N8N_ENCRYPTION_KEY=${config.sops.placeholder."stack/n8n/encryption_key"}
    '';
    owner = "n8n";
  };

  sops.templates."stack-evolution-env" = {
    content = ''
      AUTHENTICATION_API_KEY=${config.sops.placeholder."stack/evolution/api_key"}
      MONGO_INITDB_ROOT_USERNAME=evolution
      MONGO_INITDB_ROOT_PASSWORD=${config.sops.placeholder."stack/evolution/mongo_password"}
      MONGODB_CONNECTION_URI=mongodb://evolution:${config.sops.placeholder."stack/evolution/mongo_password"}@127.0.0.1:27017/evolution?authSource=admin
    '';
  };

  sops.templates."stack-postiz-env" = {
    content = ''
      DATABASE_PASSWORD=${config.sops.placeholder."stack/postiz/db_password"}
      POSTIZ_SECRET=${config.sops.placeholder."stack/postiz/secret"}
    '';
  };

  # --- Stack configuration ---
  services.stack = {
    enable = true;
    inherit domain;
    acmeEmail = "miranda.salazar@utec.edu.pe";

    odoo = {
      enable = true;
      environmentFile = config.sops.templates."stack-odoo-env".path;
    };
    n8n = {
      enable = true;
      environmentFile = config.sops.templates."stack-n8n-env".path;
    };
    evolutionApi = {
      enable = true;
      environmentFile = config.sops.templates."stack-evolution-env".path;
    };
    postiz = {
      enable = true;
      environmentFile = config.sops.templates."stack-postiz-env".path;
    };
  };

  # --- Override ACME/SSL for Cloudflare Tunnel ---
  # The mini uses Cloudflare Tunnel for SSL termination, so we disable
  # forceSSL and enableACME that the digital-solutions module sets.
  services.nginx.virtualHosts = {
    "erp.${domain}" = {
      forceSSL = lib.mkForce false;
      enableACME = lib.mkForce false;
    };
    "n8n.${domain}" = {
      forceSSL = lib.mkForce false;
      enableACME = lib.mkForce false;
    };
    "wa.${domain}" = {
      forceSSL = lib.mkForce false;
      enableACME = lib.mkForce false;
    };
    "social.${domain}" = {
      forceSSL = lib.mkForce false;
      enableACME = lib.mkForce false;
    };
  };
}
