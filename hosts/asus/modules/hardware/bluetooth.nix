{ ... }: {
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = [ "btusb" ];
}
