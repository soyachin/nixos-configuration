{
  config,
  pkgs,
  ...
}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;

    settings = {
      # Funcionalidad
      ignore-empty-password = true;
      daemonize = true;
      screenshot = true;
      indicator-caps-lock = true;
      indicator-idle-visible = true;
      clock = true;
      fade-in = 0.7;
      datestr = "%d/%m/%Y";

      # Fuentes
      font = "ComicShannsMono Nerd Font Mono";
      font-size = 20;

      # Efectos visuales
      effect-blur = "10x5";
      effect-vignette = "0.5:0.5";

      # Tamaños del indicador
      indicator-radius = 100;
      indicator-thickness = 7;

      # Colores del tema Kanagawa Bones
      # Base colors
      text-color = "#DDD8BB"; # foreground
      inside-color = "#1F1F2866"; # background con transparencia
      ring-color = "#614A82cc"; # active_tab_background
      line-color = "#00000000"; # transparent
      separator-color = "#00000000"; # transparent

      # Estados del indicador
      # Normal
      key-hl-color = "#98BC6Dcc"; # color2 green
      bs-hl-color = "#E46A78cc"; # color1 red

      # Caps Lock
      caps-lock-key-hl-color = "#E5C283cc"; # color3 yellow
      caps-lock-bs-hl-color = "#E46A78cc"; # color1 red

      # Estados del anillo interno
      inside-clear-color = "#98BC6D66"; # color2 green
      inside-caps-lock-color = "#E5C28366"; # color3 yellow
      inside-ver-color = "#7EB3C966"; # color4 blue
      inside-wrong-color = "#E46A7866"; # color1 red

      # Estados del anillo externo
      ring-clear-color = "#98BC6Dcc"; # color2 green
      ring-caps-lock-color = "#E5C283cc"; # color3 yellow
      ring-ver-color = "#7EB3C9cc"; # color4 blue
      ring-wrong-color = "#E46A78cc"; # color1 red

      # Texto en diferentes estados
      text-clear-color = "#DDD8BB"; # foreground
      text-caps-lock-color = "#DDD8BB"; # foreground
      text-ver-color = "#DDD8BB"; # foreground
      text-wrong-color = "#DDD8BB"; # foreground

      # Layout (teclado)
      layout-bg-color = "#1F1F2800"; # background transparente
      layout-text-color = "#DDD8BB"; # foreground
    };
  };
}
