{ lib, config, pkgs, ... }:
let
  cfg = config.platform.hardware.nvidia;
in
{
  config = lib.mkIf cfg.enable {
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      nvidiaSettings = true;
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
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };

    programs.gamemode.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
  };
}
