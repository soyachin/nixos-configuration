# hosts/mini/modules/services/urbania/backend.nix
# Servicio systemd para el backend FastAPI de Urbania BI.
# Corre como usuario 'urbania', lee capa serving (Parquet) desde /var/lib/urbania/serving/
{
  config,
  pkgs,
  lib,
  ...
}:
let
  pythonEnv = pkgs.callPackage ./package.nix { };
  cfg = config.services.urbania;
in
{
  systemd.services.urbania-backend = {
    description = "Urbania BI — FastAPI backend";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      PYTHONPATH = "${cfg.repoPath}/app/backend";
    };
    serviceConfig = {
      Type = "simple";
      User = "urbania";
      Group = "urbania";
      WorkingDirectory = "${cfg.repoPath}/app/backend";
      ExecStart = pkgs.writeShellScript "urbania-backend-start" ''
        VENV="${cfg.dataDir}/venv"
        if [ -f "$VENV/bin/uvicorn" ]; then
          PYTHON="$VENV/bin/python"
        else
          PYTHON="${pythonEnv}/bin/python"
        fi
        exec $PYTHON -m uvicorn main:app \
          --host 127.0.0.1 \
          --port 8000
      '';
      Restart = "on-failure";
      RestartSec = "5s";
      # DB_PATH solo se usa para resolver SERVING_DIR en queries.py
      # El backend no abre urbania.duckdb; lee serving/*.parquet
      Environment = [
        "DB_PATH=${cfg.dataDir}/urbania.duckdb"
        "PYTHONDONTWRITEBYTECODE=1"
        "CORS_ORIGINS=http://localhost:5173,http://localhost:4173,https://map.vendeconcarlos.pe"
        "CF_ACCESS_TEAM=nyarkovchain"  # cambiar por tu team real
        "CF_ACCESS_AUD=your-application-id-here"  # cambiar por tu Application ID de Cloudflare Access
      ];
      # Hardening: solo lectura sobre datos (Parquet serving layer)
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "strict";
      ReadOnlyPaths = [ cfg.dataDir ];
    };
  };
}
