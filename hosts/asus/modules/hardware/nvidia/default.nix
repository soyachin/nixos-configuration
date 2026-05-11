{ ... }: {
  imports = [
    ../../../../modules/hardware/nvidia
  ];

  platform.hardware.nvidia.enable = true;
}
