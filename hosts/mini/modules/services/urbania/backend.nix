# hosts/mini/modules/services/urbania/backend.nix
{
  config,
  pkgs,
  lib,
  sops,
  ...
}:
let
  pythonEnv = pkgs.callPackage ./package.nix { };
  cfg = config.services.urbania;
in
{
  sops.secrets."cf_access_aud" = {
    owner = "urbania";
  };

  sops.templates."urbania-backend-env" = {
    content = ''
      CF_ACCESS_AUD=${config.sops.placeholder."cf_access_aud"}
    '';
    owner = "urbania";
  };

  systemd.services.urbania-backend = {
    description = "Urbania BI — FastAPI backend";
    after = [
      "network.target"
      "sops-nix.service"
    ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      PYTHONPATH = "${cfg.repoPath}/app/backend";
      DB_PATH = "${cfg.dataDir}/urbania.duckdb";
      PYTHONDONTWRITEBYTECODE = "1";
      CORS_ORIGINS = "http://localhost:5173,http://localhost:4173,https://map.vendeconcarlos.pe";
      CF_ACCESS_TEAM = "sillao";
    };
    serviceConfig = {
      Type = "simple";
      User = "urbania";
      Group = "urbania";
      WorkingDirectory = "${cfg.repoPath}/app/backend";
      EnvironmentFile = config.sops.templates."urbania-backend-env".path;
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
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "strict";
      ReadOnlyPaths = [ cfg.dataDir ];
    };
  };
}
