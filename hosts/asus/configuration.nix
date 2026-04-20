{
  inputs,
  unstable,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./modules
    ./programs
  ];

  networking.hostName = "asus";

  # --- AAGL ---
  nix.settings = inputs.aagl.nixConfig;
  programs.anime-game-launcher.enable = true;
  programs.anime-games-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;

  # --- HOME MANAGER ---
  home-manager = {
    extraSpecialArgs = { inherit inputs unstable; };
    users.hojas = import ./home/main-user.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  system.stateVersion = "24.11";

  specialisation.server.configuration = {
    system.nixos.tags = ["server"];

    # 1. Deshabilitar Interfaz Gráfica y Software de Escritorio
    services.greetd.enable = lib.mkForce false;
    programs.niri.enable = lib.mkForce false;
    services.xserver.enable = lib.mkForce false;
    services.noctalia-shell.enable = lib.mkForce false;

    # Deshabilitar Launchers y Steam para liberar recursos
    programs.anime-game-launcher.enable = lib.mkForce false;
    programs.anime-games-launcher.enable = lib.mkForce false;
    programs.honkers-railway-launcher.enable = lib.mkForce false;
    programs.steam.enable = lib.mkForce false;

    # 2. Multimedia y periféricos
    services.pipewire.enable = lib.mkForce false;
    services.blueman.enable = lib.mkForce false;
    hardware.bluetooth.enable = lib.mkForce false;
    hardware.bluetooth.powerOnBoot = lib.mkForce false;
    services.printing.enable = lib.mkForce false;

    # 3. Bloquear suspensión
    systemd.targets.sleep.enable = lib.mkForce false;
    systemd.targets.suspend.enable = lib.mkForce false;
    systemd.targets.hibernate.enable = lib.mkForce false;
    systemd.targets.hybrid-sleep.enable = lib.mkForce false;

    # 4. Comportamiento de la tapa (nombres correctos post-rename)
    services.logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };

    # 5. Energía y recuperación
    powerManagement.cpuFreqGovernor = lib.mkForce "schedutil";
    
    # Habilitar Wake-on-LAN en la interfaz Ethernet (enp2s0)
    networking.interfaces.enp2s0.wakeOnLan.enable = true;

    # Si el kernel detecta un fallo crítico (panic), reinicia automáticamente.
    boot.kernel.sysctl = {
      "kernel.panic" = 10; # Reiniciar 10 segundos después de un panic
      "kernel.panic_on_oops" = 1; # Reiniciar también si hay un error serio (oops)
      "kernel.sysrq" = 1; # Habilitar (Magic SysRq) para rescate
      "vm.panic_on_oom" = 1; # Reiniciar si se queda sin memoria crítica (evita freeze)
    };
  };
}





