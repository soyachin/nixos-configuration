{ lib, ... }: {
  hardware.opentabletdriver.enable = lib.mkDefault true;
  hardware.uinput.enable = lib.mkDefault true;
  boot.kernelModules = lib.mkDefault [ "uinput" ];
}
