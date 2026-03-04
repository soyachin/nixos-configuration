{pkgs,...}:
let
  autoSkipper = pkgs.writeShellScriptBin "auto-f-skip" ''
    STATE_FILE="/run/user/$(id -u)/auto_f_skip.pid"

    if [ -f "$STATE_FILE" ]; then
        PID=$(cat "$STATE_FILE")
        kill "$PID" && rm "$STATE_FILE"
        ${pkgs.libnotify}/bin/notify-send "Auto-F" "OFF" -t 1000
    else
        # Bucle optimizado: rápido y con jitter humano
        (
            while true; do
                ${pkgs.ydotool}/bin/ydotool key 33:1 33:0
                # Espera aleatoria entre 1.2s y 2.5s
                WAIT=$(echo "scale=1; $((12 + RANDOM % 13)) / 10" | ${pkgs.bc}/bin/bc)
                sleep "$WAIT"
            done
        ) &
        echo $! > "$STATE_FILE"
        ${pkgs.libnotify}/bin/notify-send "Auto-F" "ON (Intervalos: 1.2s-2.5s)" -t 1000
    fi
  '';
in
{
  environment.systemPackages = [ 
    autoSkipper 
    pkgs.ydotool
    pkgs.bc
  ];

  # Niri y ydotool necesitan acceso al socket
  services.ydotool.enable = true;
  users.users.tu_usuario.extraGroups = [ "ydotool" ];
}
