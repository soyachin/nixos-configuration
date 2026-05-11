{ pkgs, ... }:
{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    audio.enable = true;
    wireplumber = {
      enable = true;
      extraConfig."51-mic-volume" = {
        "monitor.alsa.rules" = [
          {
            matches = [ { "node.name" = "alsa_input.pci-0000_06_00.6.analog-stereo"; } ];
            actions.update-props = {
              "node.volume" = 0.20;
              "volume.limit" = 0.20;
            };
          }
        ];
      };
    };
  };

  systemd.user.services.mic-volume = {
    description = "Keep mic at 20%";
    wantedBy = [ "default.target" ];
    after = [ "wireplumber.service" ];
    path = [
      pkgs.wireplumber
      pkgs.pipewire
    ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      ExecStart = pkgs.writeShellScript "mic-volume-watch" ''
        sleep 2
        wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.2
        pactl subscribe | grep --line-buffered "source" | while read -r _; do
          wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.2
          wpctl set-volume 68 0.2
        done
      '';
    };
  };
}
