{ pkgs, ... }:
{
  hardware.i2c.enable = true;
  services.udisks2.enable = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  hardware.opentabletdriver.enable = true;

  # Required by OpenTabletDriver
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];
}
