{
  writeShellApplication,
  pamixer,
  libnotify,
}:
writeShellApplication {
  name = "volume-up";
  runtimeInputs = [pamixer libnotify];
  text = ''
    pamixer -i 5
    volume=$(pamixer --get-volume)
    muted=$(pamixer --get-mute)

    if [ "$muted" = "true" ]; then
      notify-send -h string:x-canonical-private-synchronous:volume \
                  "Volume: Muted" \
                  "Volume is muted" \
                  -h int:value:0
    else
      notify-send -h string:x-canonical-private-synchronous:volume \
                  "Volume: $volume%" \
                  "Volume level" \
                  -h int:value:"$volume"
    fi
  '';
}
