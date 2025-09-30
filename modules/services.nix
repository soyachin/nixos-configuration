{
  config,
  pkgs,
  lib,
  ...
}: {
  services.displayManager.sessionPackages = [
    pkgs.niri
  ];

  environment.systemPackages = lib.optionals config.services.displayManager.sddm.enable [
    (pkgs.where-is-my-sddm-theme.override {
      variants = ["qt5"];
    })
  ];
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "where_is_my_sddm_theme_qt5";
  };

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
