{ config, pkgs, ... }: {
  imports = [ ./agent.nix ];
  services.glance = {
    enable = true;
    settings = {
      server = {
        proxied = true;
        port = 5679;
        host = "127.0.0.1";
        agent.url = "http://localhost:27973";
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
                  url = "https://jelly.${domain}";
                  check-url = "http://127.0.0.1:8096";
                  icon = "si:jellyfin";
                }
                {
                  title = "Urbania API";
                  url = "https://api.vendeconcarlos.pe";
                  check-url = "http://127.0.0.1:8000/health";
                  icon = "si:fastapi";
                }
                {
                  title = "Vaultwarden";
                  url = "https://vault.${domain}";
                  check-url = "http://127.0.0.1:8222";
                  icon = "si:bitwarden";
                }
                {
                  title = "Cockpit";
                  url = "https://netdata.${domain}";
                  check-url = "http://127.0.0.1:9090";
                  icon = "si:cockpit";
                }
                {
                  title = "Odoo";
                  url = "https://erp.${domain}";
                  check-url = "http://127.0.0.1:8069";
                  icon = "si:odoo";
                }
                {
                  title = "n8n";
                  url = "https://n8n.${domain}";
                  check-url = "http://127.0.0.1:5678";
                  icon = "si:n8n";
                }
                {
                  title = "Evolution API";
                  url = "https://wa.${domain}";
                  check-url = "http://127.0.0.1:8080";
                  icon = "si:whatsapp";
                }
                {
                  title = "Postiz";
                  url = "https://social.${domain}";
                  check-url = "http://127.0.0.1:5000";
                  icon = "si:buffer";
                }
              ];
            }
            {
              type = "custom-api";
              title = "Urbania Pipeline";
              cache = "5m";
              url = "http://127.0.0.1:8000/api/status";
              template = ''
                <div class="flex gap-10">
                  <span class="color-positive">Stock: {{ .JSON.Int "stock_total" }}</span>
                  <span>Last run: {{ .JSON.String "last_run" }}</span>
                </div>
                <div class="margin-top-10 color-foreground">
                  Status: {{ .JSON.String "status" }}
                </div>
              '';
            }
            {
              type = "server-stats";
              items = [ "cpu" "memory" "disk" "uptime" ];
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
