{
  services.glance = {
    enable = true;
    settings = {
      server = {
        proxied = true;
        port = 5678;
        host = "127.0.0.1";
      };
      theme = {
        background-color = "0 0 16";
        primary-color = "43 59 81";
        positive-color = "61 66 44";
        negative-color = "6 96 59";
      };

      branding.hide.footer = true;

      pages = let domain = "nyarkovchain.site";
      in [{
        name = "nyan :3";
        width = "slim";
        hide-desktop-navigation = true;
        center-vertically = true;
        columns = [{
          size = "full";
          widgets = [
            {
              type = "search";
              search-engine = "duckduckgo";
              autofocus = true;
            }
            {
              type = "monitor";
              cache = "1m";
              title = "Services";
              sites = [
                {
                  title = "Jellyfin";
                  url =
                    "https://jelly.${domain}"; # Lo que usa tu navegador al hacer clic
                  check-url =
                    "http://127.0.0.1:8096"; # Lo que usa Glance para el puntito verde
                  icon = "si:jellyfin";
                }
                {
                  title = "AudioBookShelf";
                  url = "https://books.${domain}"; # Lo que usa tu navegador
                  check-url =
                    "http://127.0.0.1:4000"; # (Ajusta al puerto real de ABS)
                  icon = "si:audiobookshelf";
                }
              ];
            }
            {
              type = "bookmarks";
              groups = [{
                title = "General";
                links = [
                  {
                    title = "Gmail";
                    url = "https://mail.google.com/mail/u/0/";
                  }
                  {
                    title = "Github";
                    url = "https://github.com/";
                  }
                ];
              }];
            }
          ];
        }];
      }];
    };
  };
}
