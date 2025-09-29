{
  config,
  pkgs,
  ...
}: {
  services.swayidle = {
    enable = true;
    timeouts = [
      # dimm
      {
        timeout = 300; # 5 minutes
        # -s: Saves the current brightness before dimming
        # set 15%: Dims the screen to 15%
        command = "brightnessctl -s set 15%";
        # -r: Restores the saved brightness when you resume
        resumeCommand = "brightnessctl -r";
      }
      # lock
      {
        timeout = 600; # 10 minutes
        command = "swaylock -f -c 000000"; # Locks the screen
      }
      # screen off timeout
      {
        timeout = 630; # 10 minutes and 30 seconds
        command = "swaymsg \"output * dpms off\""; # Turns off the display
        resumeCommand = "swaymsg \"output * dpms on\""; # Turns on the display when returning
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "swaylock -f -c 000000";
      }
    ];
  };
}
