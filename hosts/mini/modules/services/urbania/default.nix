# hosts/mini/modules/services/urbania/default.nix
# Módulo NixOS para Urbania BI.
# Gestiona usuario, directorios, deploy key, y servicios.
#
# Uso en configuration.nix:
#   services.urbania = {
#     enable   = true;
#     dataDir  = "/var/lib/urbania";   # default
#     repoPath = "/var/lib/urbania/repo"; # default
#   };
{ config, pkgs, lib, ... }:

let
  cfg = config.services.urbania;
in {
  imports = [
    ./backend.nix
    ./pipeline.nix
  ];

  # ─── Opciones del módulo ─────────────────────────────────────────────────
  options.services.urbania = {
    enable = lib.mkEnableOption "Urbania BI — mapa de mercado inmobiliario";

    dataDir = lib.mkOption {
      type    = lib.types.str;
      default = "/var/lib/urbania";
      description = "Directorio de datos: DBs, logs, venv.";
    };

    repoPath = lib.mkOption {
      type    = lib.types.str;
      default = "/var/lib/urbania/repo";
      description = "Path del repositorio urbania-py clonado.";
    };
  };

  # ─── Implementación ──────────────────────────────────────────────────────
  config = lib.mkIf cfg.enable {

    # Usuario dedicado sin shell de login
    users.users.urbania = {
      isSystemUser = true;
      group        = "urbania";
      home         = cfg.dataDir;
      createHome   = false;   # lo crea tmpfiles abajo
      description  = "Urbania BI service user";
    };

    users.groups.urbania = {};

    # Crear directorios con permisos correctos
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}            0750 urbania urbania -"
      "d ${cfg.dataDir}/repo       0750 urbania urbania -"
      "d ${cfg.dataDir}/logs       0750 urbania urbania -"
      "d ${cfg.dataDir}/.ssh       0700 urbania urbania -"
      "d ${cfg.dataDir}/data       0750 urbania urbania -"  # gpkg
    ];

    # Git y duckdb disponibles 
    environment.systemPackages = with pkgs; [
      git
      duckdb
    ];

    # ─── Servicio de deploy: git pull del repo privado ──────────────────
    systemd.services.urbania-deploy = {
      description = "Urbania BI — actualizar repo desde GitHub";
      after       = [ "network-online.target" ];
      wants       = [ "network-online.target" ];

      serviceConfig = {
        Type             = "oneshot";
        User             = "urbania";
        Group            = "urbania";
        WorkingDirectory = cfg.dataDir;

        ExecStart = pkgs.writeShellScript "urbania-deploy" ''
          set -euo pipefail
          REPO="${cfg.repoPath}"
          SSH_KEY="${cfg.dataDir}/.ssh/id_ed25519"

          export GIT_SSH_COMMAND="${pkgs.openssh}/bin/ssh -i $SSH_KEY -o StrictHostKeyChecking=accept-new"

          if [ ! -d "$REPO/.git" ]; then
            echo "Clonando repo por primera vez..."
            ${pkgs.git}/bin/git clone git@github.com:soyachin/urbania-py.git "$REPO"
          else
            echo "Actualizando repo..."
            ${pkgs.git}/bin/git -C "$REPO" pull --ff-only origin main
          fi

          echo "Deploy completado: $(${pkgs.git}/bin/git -C $REPO rev-parse --short HEAD)"
        '';

        RemainAfterExit  = false;
        StandardOutput   = "journal";
        StandardError    = "journal";
        SyslogIdentifier = "urbania-deploy";
        NoNewPrivileges  = true;
        PrivateTmp       = true;
        ReadWritePaths   = [ cfg.dataDir ];
      };
    };

    # ─── Timer: deploy diario antes del pipeline ────────────────────────
    systemd.timers.urbania-deploy = {
      description = "Urbania BI — timer deploy diario";
      wantedBy    = [ "timers.target" ];

      timerConfig = {
        OnCalendar  = "*-*-* 02:45:00";  # 15 min antes del pipeline
        Persistent  = true;
      };
    };

    # El pipeline depende del deploy
    systemd.services.urbania-pipeline = {
      after    = [ "urbania-deploy.service" "urbania-venv-setup.service" ];
      requires = [ "urbania-venv-setup.service" ];
      # after del deploy pero no requires — si el pull falla, corre igual con el código anterior
    };

    # El backend arranca después del venv
    systemd.services.urbania-backend = {
      after    = [ "urbania-venv-setup.service" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
