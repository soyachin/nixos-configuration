{
  config,
  pkgs,
  ...
}:
{
  services.swayidle =
    let
      lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
      display = status: "swaymsg output '*' power ${status}";
    in
    {
      enable = true;
      timeouts = [
        {
          timeout = 600;
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
      events = {
        "before-sleep" = (display "off") + "; " + lock;
        "after-resume" = display "on";
        "lock" = (display "off") + "; " + lock;
        "unlock" = display "on";
      };
    };
}
