{ config, pkgs, ... }: {
  # ---------------------------------------------------------------------
  # 1. IMPORTS & VERSIÓN DEL SISTEMA
  # ---------------------------------------------------------------------

  imports = [
    # Incluye los resultados del escaneo de hardware.
    ./hardware-configuration.nix
  ];

  # Define la versión del sistema NixOS para futuras actualizaciones.
  system.stateVersion = "25.05";

  # ---------------------------------------------------------------------
  # 2. BOOT & FIRMWARE
  # ---------------------------------------------------------------------

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

  nix.settings.trusted-users = ["root" "aoba"];

  # ---------------------------------------------------------------------
  # 3. RED & FIREWALL (Incluye Tailscale)
  # ---------------------------------------------------------------------

  networking.hostName = "mini";

  networking = {
    # Habilitar firewall
    firewall = {
      enable = true;
      # Puertos TCP permitidos (22 SSH, 8096 Jellyfin, 8000 AudioBookShelf)
      allowedTCPPorts = [ 22 8096 8000 443 80];
      # Puertos UDP permitidos (9 y 7359 para Wake-on-LAN)
      allowedUDPPorts = [ 9 7359 ];
      trustedInterfaces = [ "tailscale0" ];
    };

    # Configuración de interfaz específica (Ejemplo de Wake-on-LAN)
    interfaces.ens3.wakeOnLan.enable = true;
  };

  # Servicio de VPN (Tailscale)
  services.tailscale.enable = true;

  # Workaround para Tailscale (si es necesario por doCheck fallido)
  nixpkgs.overlays = [
    (final: prev: {
      tailscale = prev.tailscale.overrideAttrs (oldAttrs: { doCheck = false; });
    })
  ];

  # ---------------------------------------------------------------------
  # 4. SERVICIOS DE APLICACIÓN (Incluye SSH y Jellyfin)
  # ---------------------------------------------------------------------

  # Servicio SSH (Acceso Remoto)
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PermitRootLogin = "no";
      AllowUsers = [ "aoba" ];
      PasswordAuthentication = false;
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "jelly.mini.cyprus-dubhe.ts.net".extraConfig =
        "reverse_proxy localhost:8096";
      "books.mini.cyprus-dubhe.ts.net".extraConfig =
        "reverse_proxy localhost:8000";
    };
  };

  # Servicio Jellyfin (Media Server)
  services.jellyfin = {
    enable = true;
    dataDir = "/home/aoba/jellyfin/data";
    user = "aoba";
    openFirewall =
      true; # Ya cubierto en networking.firewall, pero buena práctica.
  };

  # Servicio de AudioBookShelf

  services.audiobookshelf = {
    enable = true;
    host = "0.0.0.0";
    port = 8000;
  };

  # ---------------------------------------------------------------------
  # 5. USUARIOS, CONSOLA Y LOCALIZACIÓN
  # ---------------------------------------------------------------------

  # Definición de usuarios
  users.users.aoba = {
    isNormalUser = true;
    description = "aoba";
    extraGroups = [ "networkmanager" "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPgFfodR//LxjCO0qCeeUfzyay918OtduXdJ2SejKXHm hojas@asus"
    ];
  };

  # Teclado en la consola (TTY)
  console.keyMap = "la-latin1";

  # Teclado en XServer (Si se usa)
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };

  # ---------------------------------------------------------------------
  # 6. ENTORNO Y PAQUETES
  # ---------------------------------------------------------------------

  # Variables de Entorno
  environment.variables = { TERM = "xterm"; };

  # Editor por defecto
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Paquetes disponibles en todo el sistema
  environment.systemPackages = with pkgs; [
    # Compilación y Desarrollo
    nodejs_20
    python3
    cargo
    cmake
    gcc
    lldb

    # Utilidades y CLI
    htop
    btop
    tmux
    tree
    bc # Calculadora
    lazygit
    yazi
    fastfetch

    # Media y Archivos
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    unrar
    unzip
    p7zip
    yt-dlp
  ];
}
