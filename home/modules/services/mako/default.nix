{
  config,
  pkgs,
  ...
}: {
  services.mako = {
    enable = true;
    settings = {
      font = "ComicShannsMono Nerd Font Mono 12";
      default-timeout = 3000;
      border-radius = 3;
    };
  };
}
