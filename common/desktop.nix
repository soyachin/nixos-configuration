{ ... }: {
  boot.supportedFilesystems = [ "ntfs" ];

  services.printing.enable = true;
  services.udisks2.enable = true;
  services.blueman.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = { enable = true; support32Bit = true; };
    pulse.enable = true;
    audio.enable = true;
    wireplumber.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
  };
}
