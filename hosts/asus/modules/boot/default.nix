{
  config,
  pkgs,
  ...
}: {
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
    nvidia_x11
  ];
}
