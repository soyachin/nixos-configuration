# hosts/mini/modules/security/service-limits.nix
# Resource limits por servicio para evitar que un servicio comprometido
# o bajo ataque consuma todos los recursos del servidor.
{ ... }: {
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
}
