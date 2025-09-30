{
  writeShellApplication,
  pamixer,
  libnotify,
}:
writeShellApplication {
  name = "mic-toggle";
  runtimeInputs = [pamixer libnotify];
  text = ''
    # Cambiar estado del micrófono
    pamixer --default-source -t

    # Obtener estado actual
    muted=$(pamixer --default-source --get-mute)

    if [ "$muted" = "true" ]; then
      notify-send -h string:x-canonical-private-synchronous:mic \
                  "Microphone: Muted" \
                  "Microphone is muted" \
                  -i microphone-sensitivity-muted-symbolic
    else
      notify-send -h string:x-canonical-private-synchronous:mic \
                  "Microphone: Unmuted" \
                  "Microphone is active" \
                  -i microphone-sensitivity-high-symbolic
    fi
  '';
}
