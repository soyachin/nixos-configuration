{ pkgs, ... }: {
  imports = [ 
    ./aliases.nix 
  ];

  # ---------------------------------------------------------------------
  # 1. NIX & GESTIÓN DE PAQUETES
  # ---------------------------------------------------------------------

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # ---------------------------------------------------------------------
  # 2. RED
  # ---------------------------------------------------------------------

  networking = {
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" ];
    firewall.enable = true;
  };

  services.tailscale.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      tailscale = prev.tailscale.overrideAttrs (_: { doCheck = false; });
    })
  ];

  # ---------------------------------------------------------------------
  # 3. LOCALIZACIÓN & HORA
  # ---------------------------------------------------------------------

  time.timeZone = "America/Lima";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS        = "es_PE.UTF-8";
      LC_IDENTIFICATION = "es_PE.UTF-8";
      LC_MEASUREMENT    = "es_PE.UTF-8";
      LC_MONETARY       = "es_PE.UTF-8";
      LC_NAME           = "es_PE.UTF-8";
      LC_NUMERIC        = "es_PE.UTF-8";
      LC_PAPER          = "es_PE.UTF-8";
      LC_TELEPHONE      = "es_PE.UTF-8";
      LC_TIME           = "es_PE.UTF-8";
    };
  };

  # ---------------------------------------------------------------------
  # 4. PAQUETES DEL SISTEMA
  # ---------------------------------------------------------------------

  # Editor por defecto
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    # Utilidades y CLI
    git
    tmux
    lazygit
    fastfetch
    htop
    btop
    tree
    nitch
    acpi
    rmtrash
    ffmpeg
    # Archivos y búsqueda
    lsd
    ripgrep
    fzf
    bat
    fd
    eza
    zoxide

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

    pciutils usbutils dmidecode smartmontools # hardware / bus 
    lsof ethtool tcpdump nmap # red 
    strace procs # process
    ncdu iotop # disk / io
    lm_sensors powertop # energy 
    bc lldb # common and debugging
  ];

  # ---------------------------------------------------------------------
  # 5. SOPS
  # ---------------------------------------------------------------------

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
