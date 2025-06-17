# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:


{
  nixpkgs.config.allowUnfree = true;


  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager

    ];


  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
    nvidia_x11
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  # Configuración de NVIDIA (dedicada)

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:6:0";  # AMD
      nvidiaBusId = "PCI:0:1:0";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      amdvlk 
      mesa 
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      amdvlk # Versión de 32 bits
      mesa
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos"; # Define your hostname.

  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  networking.networkmanager.enable = true;
  systemd.services."NetworkManager-wait-online.service".enable = false;
  networking.firewall.enable = true;

  # Set your time zone.
  time.timeZone = "America/Lima";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "latam";
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  programs.firefox  =  {
    enable  =  true ;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    audio.enable = true;
    wireplumber.enable = true;
  };

  programs.zsh.enable = true;

  users.users.hojas = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "bluetooth" ];
  };

  environment.systemPackages = with pkgs; [
    unrar p7zip unzip yt-dlp wget librewolf scrcpy tmux zsh git tree
    kdePackages.konsole gparted vlc
    openvpn gnome-boxes bottles
    obs-studio vesktop qbittorrent gimp xournalpp easyeffects inkscape input-remapper
    clang-tools
    lldb
    krita pinta
    v4l-utils libva-utils vdpauinfo libvdpau libva
    libva-vdpau-driver glxinfo vulkan-tools mpv
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers

    extraPackages = with pkgs; [
          # Video/Audio data composition framework tools like "gst-inspect", "gst-launch"...
          gst_all_1.gstreamer
          # Common plugins like "filesrc" to combine within e.g. gst-launch
          gst_all_1.gst-plugins-base
          # Specialized plugins separated by quality
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-bad
          gst_all_1.gst-plugins-ugly
          # Plugins to reuse ffmpeg to play almost every video format
          gst_all_1.gst-libav
          # Support the Video Audio (Hardware) Acceleration API
          gst_all_1.gst-vaapi
          #...
          ffmpeg_6-full
    ];
  };

  services.input-remapper = {
    enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts noto-fonts-cjk-sans noto-fonts-emoji liberation_ttf
    aileron fragment-mono comic-mono work-sans hubot-sans eurofurence
    dosis manrope montserrat helvetica-neue-lt-std
    nerd-fonts.fira-code
    nerd-fonts.ubuntu
    nerd-fonts.hack
    nerd-fonts.comic-shanns-mono

    carlito dejavu_fonts ipafont kochi-substitute source-code-pro
    ttf_bitstream_vera
  ];

  nix.gc.options = "--delete-older-than 7d";

  hardware.i2c.enable = true;
  # virtualisation.virtualbox.host.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  system.stateVersion = "24.11"; # Did you read the comment?

}
