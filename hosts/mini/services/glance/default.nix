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
        name = "Startpage";
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
                  url = "https://gello.${domain}";
                  icon = "si:jellyfin";
                }
                {
                  title = "AudioBookShelf";
                  url = "https://worm.${domain}";
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
