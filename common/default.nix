{config, pkgs, ...}: {

  imports = [
    ./aliases.nix
  ];
  # ---------------------------------------------------------------------
  # 1. NIX & GESTIÓN DE PAQUETES
  # ---------------------------------------------------------------------

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # ---------------------------------------------------------------------
  # 2. HARDWARE & SERVICIOS DE BAJO NIVEL
  # ---------------------------------------------------------------------

  boot.supportedFilesystems = ["ntfs"];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.udisks2.enable = true;
  services.blueman.enable = true;

  # Audio (PipeWire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    audio.enable = true;
    wireplumber.enable = true;
  };

  hardware.bluetooth.enable = true;

  # ---------------------------------------------------------------------
  # 3. RED
  # ---------------------------------------------------------------------

  networking = {
    networkmanager.enable = true;
    nameservers = ["1.1.1.1" "1.0.0.1"];
    firewall.enable = true;
  };

  services.tailscale.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      tailscale = prev.tailscale.overrideAttrs (oldAttrs: {
        doCheck = false;
      });
    })
  ];
  # ---------------------------------------------------------------------
  # 4. LOCALIZACIÓN & HORA
  # ---------------------------------------------------------------------

  time.timeZone = "America/Lima";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    # Configuración regional extendida (Moneda, Fecha, Teléfono, etc. para Perú)
    extraLocaleSettings = {
      LC_ADDRESS = "es_PE.UTF-8";
      LC_IDENTIFICATION = "es_PE.UTF-8";
      LC_MEASUREMENT = "es_PE.UTF-8";
      LC_MONETARY = "es_PE.UTF-8";
      LC_NAME = "es_PE.UTF-8";
      LC_NUMERIC = "es_PE.UTF-8";
      LC_PAPER = "es_PE.UTF-8";
      LC_TELEPHONE = "es_PE.UTF-8";
      LC_TIME = "es_PE.UTF-8";
    };
  };

  # ---------------------------------------------------------------------
  # 5. PAQUETES DEL SISTEMA
  # ---------------------------------------------------------------------

  environment.systemPackages = with pkgs; [
    # Utilidades y CLI
    git
    tmux
    neovim
    lazygit
    fastfetch
    htop
    btop
    tree
    nitch
    acpi
    rmtrash

    # Archivos y búsqueda
    yazi
    lsd
    ripgrep
    fzf
    bat

    # Descompresión y descargas
    unrar
    unzip
    p7zip
    yt-dlp
    wget
    curl

    # Desarrollo y Seguridad
    nodejs_20
    python3
    cargo
    sops
    age
    ntfs3g
  ];
}
