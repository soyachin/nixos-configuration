{
  config,
  pkgs,
  ...
}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;

    settings = {
      ignore-empty-password = true;
      daemonize = true;
      indicator-caps-lock = true;
      indicator-idle-visible = true;
      clock = true;
      fade-in = 0.7;
      datestr = "%d/%m/%Y";
      font = "ComicShannsMono Nerd Font Mono";
      font-size = 20;
      indicator-radius = 100;
      indicator-thickness = 7;

      #effect-blur = "10x5";
      #effect-greyscale = true;
      #effect-vignette = "0.5:0.5";
      color = "282828";
      bs-hl-color = "7daea3cc";
      caps-lock-bs-hl-color = "7daea3cc";
      caps-lock-key-hl-color = "d3869bcc";
      key-hl-color = "a9b665cc";

      inside-color = "32302f66";
      inside-clear-color = "89b48266";
      inside-caps-lock-color = "e78a4e66";
      inside-ver-color = "7daea366";
      inside-wrong-color = "ea696266";

      ring-color = "e78a4ecc";
      ring-clear-color = "89b482cc";
      ring-caps-lock-color = "e78a4ecc";
      ring-ver-color = "7daea3cc";
      ring-wrong-color = "ea6962cc";

      text-color = "d4be98";
      text-clear-color = "d4be98";
      text-caps-lock-color = "d4be98";
      text-ver-color = "d4be98";
      text-wrong-color = "d4be98";

      layout-bg-color = "32302f00";
      layout-text-color = "d4be98";
      line-color = "00000000";
      separator-color = "00000000";
    };
  };
}
