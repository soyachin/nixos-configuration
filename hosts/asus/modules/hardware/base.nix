{
  config,
  pkgs,
  ...
}: {
  hardware.i2c.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.opentabletdriver.enable = true;
}
