{
  config,
  pkgs,
  ...
}: {
  services.mako = {
    enable = true;
    settings = {
      # gruvbox
      background-color = "#282828";
      text-color = "#ebdbb2";
      border-color = "#98971a";
      progress-color = "#b8bb26";

      border-size = 1;
      border-radius = 5;
      default-timeout = 5000;
      font = "ComicShannsMono Nerd Font Mono 12";

      anchor = "top-right";
      margin = "30,30,10,10";

      "urgency=high" = {
        background-color = "#cc241d";
        border-color = "#fb4934";
        default-timeout = 0;
      };

      "urgency=low" = {
        background-color = "#3c3836";
        text-color = "#a89984";
        border-color = "#665c54";
      };
    };
  };
}
