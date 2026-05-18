# hosts/mini/modules/services/vector/default.nix
# Vector agente ligero para logs estructurados desde journald
# Lee journal de systemd de los servicios urbania y escribe NDJSON
{
  config,
  ...
}:
let
  cfg = config.services.urbania;
  logDir = "${cfg.dataDir}/logs";
in
{
  services.vector = {
    enable = true;
    journaldAccess = true;
    settings = {
      data_dir = "/var/lib/vector";

      sources = {
        urbania_journal = {
          type = "journald";
          include_units = [
            "urbania-backend"
            "urbania-scraper"
            "urbania-pipeline"
            "urbania-deploy"
          ];
        };
      };

      transforms = {
        urbania_parse = {
          type = "remap";
          inputs = [ "urbania_journal" ];
          source = ''
            .timestamp = .timestamp
            .service = .SYSLOG_IDENTIFIER ?? "urbania"
            .message = .message ?? ""
          '';
        };
      };

      sinks = {
        urbania_ndjson = {
          type = "file";
          inputs = [ "urbania_parse" ];
          path = "${logDir}/urbania-%Y-%m-%d.json";
          encoding = {
            codec = "json";
          };
        };
      };
    };
  };

  # Directorio de logs con permisos para vector y urbania
  systemd.tmpfiles.rules = [
    "d ${logDir} 0770 vector urbania -"
  ];

  # Vector necesita pertenecer al grupo urbania para escribir en su directorio
  users.users.vector.extraGroups = [ "urbania" ];
}
