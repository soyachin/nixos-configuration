{
  config,
  pkgs,
  ...
}: {
  services.displayManager.sddm.wayland.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "latam";
  };

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

  systemd.services."NetworkManager-wait-online.service".enable = false;

  services.tailscale.enable = true;

  services.xserver.videoDrivers = ["nvidia"];
}
