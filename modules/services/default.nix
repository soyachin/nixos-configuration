{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    audio.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth service
  services.blueman.enable = true;

  # NM option
  systemd.services."NetworkManager-wait-online.service".enable = false;

  # Enable udisks2 for udiskie
  services.udisks2.enable = true;
}
