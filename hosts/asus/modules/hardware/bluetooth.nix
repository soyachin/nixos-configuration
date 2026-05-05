{ ... }:
{
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = [ "btusb" ];

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Udev rules para DS4
  services.udev.extraRules = ''
    KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0660", TAG+="uaccess"
    KERNEL=="hidraw*", KERNELS=="*054C:09CC*", MODE="0660", TAG+="uaccess"
  '';

  # Grupos del usuario
  users.users.hojas.extraGroups = [
    "input"
    "bluetooth"
  ];
}
