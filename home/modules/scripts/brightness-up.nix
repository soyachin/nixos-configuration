{
  writeShellApplication,
  brightnessctl,
  libnotify,
}:
writeShellApplication {
  name = "brightness-up";
  runtimeInputs = [brightnessctl libnotify];
  text = ''
    brightnessctl set 5%+
    brightness=$(brightnessctl get)
    max_brightness=$(brightnessctl max)
    percentage=$((brightness * 100 / max_brightness))

    notify-send -h string:x-canonical-private-synchronous:brightness \
                "Brightness: $percentage%" \
                "Screen brightness" \
                -h int:value:"$percentage"
  '';
}
