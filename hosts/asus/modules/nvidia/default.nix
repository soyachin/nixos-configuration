{
  config,
  pkgs,
  ...
}: {
  # Configuración de NVIDIA (dedicada
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    powerManagement.finegrained = true;

    open = false;

    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:6:0:0"; 
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };  
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  services.xserver.videoDrivers = ["nvidia"];
}
