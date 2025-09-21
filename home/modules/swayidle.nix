{
  config,
  pkgs,
  ...
}: {
  services.swayidle = {
    enable = true;
    settings = {
      timeouts = [
        {
          timeout = 300; # 5 minutos
          command = "swaylock -f -c 000000"; # Bloquea la pantalla
        }
        {
          timeout = 600; # 10 minutos
          command = "swaymsg \"output * dpms off\""; # Apaga la pantalla
          resumeCommand = "swaymsg \"output * dpms on\""; # Enciende la pantalla al volver
        }
      ];
      before-sleep = "swaylock -f -c 000000"; # Bloquea antes de suspender
    };
  };
}
