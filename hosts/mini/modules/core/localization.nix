{ ... }: {
  # Teclado en la consola (TTY)
  console.keyMap = "la-latin1";

  # Teclado en XServer (Si se usa)
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };
}
