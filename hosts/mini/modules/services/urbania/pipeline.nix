# hosts/mini/modules/services/urbania/pipeline.nix
{
  config,
  pkgs,
  lib,
  ...
}:
let
  pythonEnv = pkgs.callPackage ./package.nix { };
  cfg = config.services.urbania;
  setupVenv = pkgs.writeShellScript "urbania-setup-venv" ''
    set -euo pipefail
    VENV="${cfg.dataDir}/venv"
    if [ ! -f "$VENV/bin/activate" ]; then
      echo "Creando virtualenv en $VENV..."
      ${pythonEnv}/bin/python -m venv --system-site-packages "$VENV"
    fi
    if ! "$VENV/bin/python" -c "import curl_cffi" 2>/dev/null; then
      echo "Instalando curl-cffi..."
      "$VENV/bin/pip" install --no-cache-dir curl-cffi==0.7.4
    fi
    echo "Venv listo."
  '';
  runScraper = pkgs.writeShellScript "urbania-scraper" ''
    set -euo pipefail
    VENV="${cfg.dataDir}/venv"
    REPO="${cfg.repoPath}"
    DATA="${cfg.dataDir}"
    export PYTHONPATH="$REPO:$REPO/app/backend"
    export PATH="$VENV/bin:${pythonEnv}/bin:$PATH"
    cd "$DATA"
    RUN_ID=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    echo "=== [1/2] Scraper (run_id=$RUN_ID) ==="
    python -m scraper.main --mode daily --batch-size 5 --batch-delay 45 --run-id "$RUN_ID"
    echo "=== [2/2] Backfill activos ==="
    python "$REPO/scripts/backfill_activo.py" --run-id "$RUN_ID" --limit 100 --stale-days 7
    echo "=== Scraper completado ==="
  '';
  runPipeline = pkgs.writeShellScript "urbania-pipeline" ''
    set -euo pipefail
    VENV="${cfg.dataDir}/venv"
    REPO="${cfg.repoPath}"
    DATA="${cfg.dataDir}"
    DUCKDB="${pkgs.duckdb}/bin/duckdb"
    export PYTHONPATH="$REPO:$REPO/app/backend"
    export PATH="$VENV/bin:${pythonEnv}/bin:$PATH"
    cd "$DATA"
    echo "=== [1/8] Migrate SQLite → DuckDB ==="
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/01_migrate.sql"
    echo "=== [2/8] Silver setup ==="
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/02a_silver_setup.sql"
    echo "=== [3/8] Silver base ==="
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/02b_silver_base.sql"
    echo "=== [4/8] Silver transforms ==="
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/02c_silver_precio.sql"
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/02d_silver_area.sql"
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/02e_silver_bbox.sql"
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/02f_silver_geo.sql"
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/02g_silver_mad.sql"
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/02h_silver_descartes.sql"
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/02i_silver_metrics.sql"
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/02j_silver_dq_rules.sql"
    echo "=== [5/8] Gold ==="
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/03_gold_sql.sql"
    echo "=== [6/8] Metabase views ==="
    "$DUCKDB" "$DATA/urbania.duckdb" < "$REPO/scripts/04_metabase_queries.sql"
    echo "=== [7/8] Export serving layer → Parquet ==="
    DB_PATH="$DATA/urbania.duckdb" "$VENV/bin/python" "$REPO/scripts/export_serving.py"
    echo "=== [8/8] Sanity checks ==="
    echo "Pipeline completado. run_id: $($DUCKDB "$DATA/urbania.duckdb" -noheader -csv -c \"SELECT run_id FROM gold.current_run\")"
    echo "=== Pipeline completado ==="
  '';
in
{
  # ─── Venv setup ──────────────────────────────────────────────────────────
  systemd.services.urbania-venv-setup = {
    description = "Urbania BI — preparar virtualenv Python";
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "urbania";
      Group = "urbania";
      ExecStart = setupVenv;
      RemainAfterExit = true;
      PrivateTmp = true;
      NoNewPrivileges = true;
      ReadWritePaths = [ cfg.dataDir ];
    };
  };
  # ─── Scraper ─────────────────────────────────────────────────────────────
  systemd.services.urbania-scraper = {
    description = "Urbania BI — scraper diario (bronze)";
    after = [
      "network.target"
      "urbania-venv-setup.service"
    ];
    requires = [ "urbania-venv-setup.service" ];
    # Cuando el scraper termina exitosamente, dispara el pipeline (no bloqueante)
    unitConfig.OnSuccess = [ "urbania-pipeline.service" ];
    serviceConfig = {
      Type = "oneshot";
      User = "urbania";
      Group = "urbania";
      WorkingDirectory = cfg.dataDir;
      ExecStart = runScraper;
      TimeoutStartSec = "2h";
      StandardOutput = "journal";
      StandardError = "journal";
      SyslogIdentifier = "urbania-scraper";
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "strict";
      ReadWritePaths = [ cfg.dataDir ];
    };
  };
  # ─── Pipeline (se dispara automáticamente cuando scraper termina) ────────
  systemd.services.urbania-pipeline = {
    description = "Urbania BI — pipeline diario (transform + export)";
    after = [ "urbania-scraper.service" ];
    serviceConfig = {
      Type = "oneshot";
      User = "urbania";
      Group = "urbania";
      WorkingDirectory = cfg.dataDir;
      ExecStart = runPipeline;
      TimeoutStartSec = "1h";
      StandardOutput = "journal";
      StandardError = "journal";
      SyslogIdentifier = "urbania-pipeline";
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "strict";
      ReadWritePaths = [ cfg.dataDir ];
    };
  };
  # ─── Timer: solo dispara el scraper ──────────────────────────────────────
  systemd.timers.urbania-scraper = {
    description = "Urbania BI — timer scraper diario";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
      RandomizedDelaySec = "15m";
    };
  };
}
