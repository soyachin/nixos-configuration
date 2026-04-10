{ ... }: {
  # Gestor de arranque (systemd-boot)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Habilitar firmware redistribuible (necesario para drivers específicos)
  hardware.enableRedistributableFirmware = true;

  # Configuración para forzar el reenvío de tráfico (para uso como router/gateway, VPN)
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # Deshabilitar todos los modos de suspensión (típico de servidor)
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';
}
