{ pkgs, config, ... }:

let
  auto-f-skip = pkgs.writeShellScriptBin "auto-f-skip" ''
    # Forzamos la ruta del socket que usaremos en el servicio manual
    export YDOTOOL_SOCKET="/run/ydotoold/socket"
    STATE_FILE="/run/user/$(id -u)/auto_f_skip.pid"

    if [ -f "$STATE_FILE" ]; then
        PID=$(cat "$STATE_FILE")
        kill -- -$(ps -o pgid= -p "$PID") && rm "$STATE_FILE"
        ${pkgs.libnotify}/bin/notify-send "Auto-F" "DESACTIVADO"
    else
        setsid bash -c '
            while true; do
                ${pkgs.ydotool}/bin/ydotool key 33:1
                sleep 0.1
                ${pkgs.ydotool}/bin/ydotool key 33:0
                WAIT=$(echo "scale=1; ($RANDOM % 15 + 10) / 10" | ${pkgs.bc}/bin/bc)
                sleep "$WAIT"
            done
        ' &
        echo $! > "$STATE_FILE"
        ${pkgs.libnotify}/bin/notify-send "Auto-F" "ACTIVADO"
    fi
  '';
in
{
  environment.systemPackages = [ auto-f-skip pkgs.ydotool pkgs.bc pkgs.libnotify ];

  # CREAMOS EL SERVICIO MANUALMENTE
  systemd.services.ydotoold = {
    description = "ydotool deamon para emulación de teclado";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.ydotool}/bin/ydotoold --socket-path=/run/ydotoold/socket --socket-own=1000:1000";
      RuntimeDirectory = "ydotoold";
      # Asegura que el dispositivo uinput tenga permisos
      ExecStartPre = "${pkgs.bash}/bin/bash -c 'chmod 666 /dev/uinput || true'";
    };
  };

  # Permisos para el usuario (ajusta 'hojas' si es necesario)
  users.users.hojas.extraGroups = [ "ydotool" "input" ];
}
