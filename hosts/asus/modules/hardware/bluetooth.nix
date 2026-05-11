{ ... }:
{
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = [ "btusb" ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;

  services.udev.extraRules = ''
    KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0660", TAG+="uaccess"
    KERNEL=="hidraw*", KERNELS=="*054C:09CC*", MODE="0660", TAG+="uaccess"
  '';

  users.users.hojas.extraGroups = [
    "input"
    "bluetooth"
  ];
}
