{ pkgs, ... }:
{
  hardware.i2c.enable = true;
  services.udisks2.enable = true;
  hardware.firmware = [ pkgs.linux-firmware ];
}
