{
  config,
  pkgs,
  ...
}: {
  hardware.i2c.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Driver de tablet
  hardware.opentabletdriver.enable = true;
}
