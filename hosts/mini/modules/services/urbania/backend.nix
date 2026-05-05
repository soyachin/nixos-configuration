# hosts/mini/modules/services/urbania/backend.nix
# Servicio systemd para el backend FastAPI de Urbania BI.
# Corre como usuario 'urbania', lee urbania.duckdb desde /var/lib/urbania/
{ config, pkgs, lib, ... }:

let
  pythonEnv = pkgs.callPackage ./package.nix {};
  cfg = config.services.urbania;
in {
  systemd.services.urbania-backend = {
    description = "Urbania BI — FastAPI backend";
    after       = [ "network.target" ];
    wantedBy    = [ "multi-user.target" ];

    environment = {
      # El backend busca urbania.duckdb relativo a su workingDir
      PYTHONPATH = "${cfg.repoPath}/app/backend";
    };

    serviceConfig = {
      Type            = "simple";
      User            = "urbania";
      Group           = "urbania";
      WorkingDirectory = "${cfg.repoPath}/app/backend";

      # Usa el venv que pipeline.nix crea en preStart
      # Si el venv no existe todavía, usa el pythonEnv de nixpkgs igual
      ExecStart = pkgs.writeShellScript "urbania-backend-start" ''
        VENV="${cfg.dataDir}/venv"
        if [ -f "$VENV/bin/uvicorn" ]; then
          PYTHON="$VENV/bin/python"
        else
          PYTHON="${pythonEnv}/bin/python"
        fi
        exec $PYTHON -m uvicorn main:app \
          --host 127.0.0.1 \
          --port 8000 \
          --workers 2
      '';

      Restart    = "on-failure";
      RestartSec = "5s";

      # El duckdb vive en /var/lib/urbania/
      # WorkingDirectory está en el repo, pero duckdb path se resuelve
      # desde queries.py via DB_PATH relativo — override con env var
      Environment = [
        "DB_PATH=${cfg.dataDir}/urbania.duckdb"
      ];

      # Hardening básico
      NoNewPrivileges  = true;
      PrivateTmp       = true;
      ProtectHome      = true;
      ProtectSystem    = "strict";
      ReadWritePaths   = [ cfg.dataDir ];
    };
  };
}
