# hosts/mini/modules/security/service-limits.nix
# Resource limits por servicio para evitar que un servicio comprometido
# o bajo ataque consuma todos los recursos del servidor.
{ lib, ... }:
{
  # --- Servicios base ---
  systemd.services.jellyfin.serviceConfig = {
    MemoryMax = "2G";
    MemoryHigh = "1536M";
    CPUQuota = "200%";
    TasksMax = 128;
  };

  systemd.services.nginx.serviceConfig = {
    MemoryMax = "256M";
    CPUQuota = "100%";
    LimitNOFILE = 8192;
  };

  systemd.services.vaultwarden.serviceConfig = {
    MemoryMax = "256M";
    CPUQuota = "50%";
    TasksMax = 32;
  };

  systemd.services.cockpit.serviceConfig = {
    MemoryMax = "256M";
    CPUQuota = "50%";
    TasksMax = 32;
  };

  systemd.services.glance.serviceConfig = {
    MemoryMax = "128M";
    CPUQuota = "25%";
    TasksMax = 16;
  };

  systemd.services.vector.serviceConfig = {
    MemoryMax = "256M";
    CPUQuota = "50%";
    TasksMax = 32;
  };

  # --- digital-solutions (Odoo, n8n, containers) ---
  systemd.services.odoo.serviceConfig = {
    MemoryMax = "1G";
    MemoryHigh = "768M";
    CPUQuota = "150%";
    TasksMax = 64;
  };

  systemd.services.n8n.serviceConfig = {
    MemoryMax = "512M";
    MemoryHigh = "384M";
    CPUQuota = "100%";
    TasksMax = 64;
  };

  systemd.services."podman-evolution-api".serviceConfig = {
    MemoryMax = "512M";
    CPUQuota = "100%";
    TasksMax = 64;
  };

  systemd.services."podman-mongodb".serviceConfig = {
    MemoryMax = "512M";
    CPUQuota = "100%";
    TasksMax = 64;
  };

  systemd.services."podman-postiz".serviceConfig = {
    MemoryMax = "512M";
    CPUQuota = "100%";
    TasksMax = 64;
  };

  # --- urbania ---
  systemd.services.urbania-backend.serviceConfig = {
    MemoryMax = "512M";
    CPUQuota = "150%";
    TasksMax = 64;
  };

  services.urbania.backend.extraEnvironment = {
    OPENBLAS_NUM_THREADS = "1";
    OMP_NUM_THREADS = "1";
  };

  # services.urbania.backend.extraServiceConfig = {
  #   SystemCallFilter = lib.mkForce "";
  #   LockPersonality = lib.mkForce false;
  # };
}
