# hosts/mini/modules/services/urbania/pipeline.nix
# Servicios systemd para el scraper y el pipeline de Urbania BI.
# Orden de ejecución diaria:
#   1. scraper      → actualiza listings.db (SQLite bronze)
#   2. backfill     → verifica activos
#   3. migrate      → copia SQLite → DuckDB
#   4. transform    → silver (filtros + geo join + MAD)
#   5. gold         → gold.deals materializado
#   6. metabase     → vistas BI
# Después del pipeline, reinicia el backend para que lea el DuckDB nuevo.
{ config, pkgs, lib, ... }:

let
  pythonEnv = pkgs.callPackage ./package.nix {};
  cfg       = config.services.urbania;

  # Script que prepara el venv con curl-cffi (solo si no existe)
  setupVenv = pkgs.writeShellScript "urbania-setup-venv" ''
    set -euo pipefail
    VENV="${cfg.dataDir}/venv"

    if [ ! -f "$VENV/bin/activate" ]; then
      echo "Creando virtualenv en $VENV..."
      ${pythonEnv}/bin/python -m venv --system-site-packages "$VENV"
    fi

    # Instalar/actualizar curl-cffi si no está
    if ! "$VENV/bin/python" -c "import curl_cffi" 2>/dev/null; then
      echo "Instalando curl-cffi..."
      "$VENV/bin/pip" install --no-cache-dir curl-cffi==0.7.4
    fi

    echo "Venv listo."
  '';

  # Script principal del pipeline completo
  runPipeline = pkgs.writeShellScript "urbania-pipeline" ''
    set -euo pipefail
    VENV="${cfg.dataDir}/venv"
    REPO="${cfg.repoPath}"
    DATA="${cfg.dataDir}"
    DUCKDB="${pkgs.duckdb}/bin/duckdb"

    export PYTHONPATH="$REPO:$REPO/app/backend"
    export PATH="$VENV/bin:${pythonEnv}/bin:$PATH"

    cd "$DATA"

    echo "=== [1/6] Scraper ==="
    python -m scraper.main --mode daily --batch-size 5 --batch-delay 45

    echo "=== [2/6] Backfill activos ==="
    python "$REPO/scripts/backfill_activo.py" --limit 100 --stale-days 7

    echo "=== [3/6] Migrate SQLite → DuckDB ==="
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/01_migrate.sql"

    echo "=== [4/6] Transform silver ==="
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/02_silver_sql.sql"

    echo "=== [5/6] Gold ==="
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/03_gold_sql.sql"

    echo "=== [6/6] Metabase views ==="
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/04_metabase_queries.sql"

    echo "=== Pipeline completado. Reiniciando backend... ==="
    systemctl restart urbania-backend
  '';

in {
  # ─── Servicio: setup del venv (corre antes del pipeline) ─────────────────
  systemd.services.urbania-venv-setup = {
    description = "Urbania BI — preparar virtualenv Python";
    after       = [ "network.target" ];

    serviceConfig = {
      Type             = "oneshot";
      User             = "urbania";
      Group            = "urbania";
      ExecStart        = setupVenv;
      RemainAfterExit  = true;

      # Necesita red para pip install
      PrivateTmp       = true;
      NoNewPrivileges  = true;
      ReadWritePaths   = [ cfg.dataDir ];
    };
  };

  # ─── Servicio: pipeline completo ─────────────────────────────────────────
  systemd.services.urbania-pipeline = {
    description = "Urbania BI — pipeline diario (scrape + transform)";
    after       = [ "network.target" "urbania-venv-setup.service" ];
    requires    = [ "urbania-venv-setup.service" ];

    serviceConfig = {
      Type             = "oneshot";
      User             = "urbania";
      Group            = "urbania";
      WorkingDirectory = cfg.dataDir;
      ExecStart        = runPipeline;

      # El pipeline puede tardar bastante
      TimeoutStartSec  = "3h";

      # Logs en el journal con identificador claro
      StandardOutput   = "journal";
      StandardError    = "journal";
      SyslogIdentifier = "urbania-pipeline";

      NoNewPrivileges  = true;
      PrivateTmp       = true;
      ProtectHome      = true;
      ProtectSystem    = "strict";
      ReadWritePaths   = [ cfg.dataDir "/run/systemd/system" ];
    };
  };

  # ─── Timer: corre el pipeline una vez al día a las 3 AM ──────────────────
  systemd.timers.urbania-pipeline = {
    description  = "Urbania BI — timer pipeline diario";
    wantedBy     = [ "timers.target" ];

    timerConfig = {
      OnCalendar       = "*-*-* 03:00:00";
      Persistent       = true;   # si el mini estaba apagado, corre al arrancar
      RandomizedDelaySec = "15m"; # evita hit exacto a las 3:00
    };
  };
}
