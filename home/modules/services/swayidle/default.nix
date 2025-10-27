{
  config,
  pkgs,
  ...
}: {
  services.swayidle = let
    lock = "${config.programs.swaylock.package}/bin/swaylock";
    display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
  in {
    enable = true;
    timeouts = [
      {
        timeout = 600;
        command = "notify-send 'Bloqueando en 2 minutos'";
      }
      {
        timeout = 720;
        command = lock;
      } # 12 min
      {
        timeout = 1200;
        command = display "off";
      } # 20 min
      {
        timeout = 2000;
        command = "systemctl suspend";
      } # 60 min
    ];
    events = [
      {
        event = "before-sleep";
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
