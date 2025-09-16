{ config, pkgs, ...}:

{
  hardware.i2c.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

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

  # Driver de tablet
  hardware.opentabletdriver.enable = true;

}