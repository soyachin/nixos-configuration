{
  config,
  pkgs,
  ...
}: {
  services.swayidle = let
    lock = "${config.programs.swaylock.package}/bin/swaylock";
    display = status: "${pkgs.hyprland}/bin/hyprctl dispatch dpms ${status}";
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
      } # ~33 min
    ];
    events = {
      before-sleep = "${display "off"} ; ${lock}";
      after-resume = display "on";
      lock = "${display "off"} ; ${lock}";
      unlock = display "on";
    };
  };
}
