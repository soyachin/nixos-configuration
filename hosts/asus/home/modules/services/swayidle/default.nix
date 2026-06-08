{
  config,
  pkgs,
  ...
}:
{
  services.swayidle =
    let
      lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
      display = status: "hyprctl dispatch dpms ${status}";
    in
    {
      enable = true;
      timeouts = [
        {
          timeout = 600; # in seconds
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 2min'";
        }
        {
          timeout = 720;
          command = lock;
        }
        {
          timeout = 1200;
          command = display "off";
          resumeCommand = display "on";
        }
        {
          timeout = 2000;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = [
        {
          event = "before-sleep";
          # adding duplicated entries for the same event may not work
          command = (display "off") + "; " + lock;
        }
        {
          event = "after-resume";
          command = display "on";
        }
        {
          event = "lock";
          command = (display "off") + "; " + lock;
        }
        {
          event = "unlock";
          command = display "on";
        }
      ];
    };
}
