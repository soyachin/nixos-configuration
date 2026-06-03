{ config, pkgs, lib, ... }:

let
  inherit (pkgs) yaziPlugins;
in
{
  programs.yazi = {
    enable = true;

    plugins = {
      smart-enter  = yaziPlugins.smart-enter;
      toggle-pane  = yaziPlugins.toggle-pane;
      restore      = yaziPlugins.restore;
      mount        = yaziPlugins.mount;
      git          = yaziPlugins.git;
      full-border  = yaziPlugins.full-border;
      what-size    = pkgs.fetchFromGitHub {
        owner  = "pirafrank";
        repo   = "what-size.yazi";
        rev    = "main";
        sha256 = "sha256-s2BifzWr/uewDI6Bowy7J+5LrID6I6OFEA5BrlOPNcM=";
      };
    };

    settings = {
      yazi = {
        manager = {
          show_symlink = true;
          linemode = "size";
        };

        opener = {
          play = [{ run = ''mpv "$@"''; orphan = true; for = "unix"; }];
          edit = [{ run = ''nvim "$@"''; block = true; for = "unix"; }];
          open = [{ run = ''xdg-open "$@"''; desc = "open"; }];
        };

        open = {
          prepend_rules = [
            { mime = "text/*"; use = "edit"; }
            { mime = "video/*"; use = "play"; }
          ];
        };
      };

      keymap = {
        mgr = {
          prepend_keymap = [
            {
              on = "j";
              run = "arrow 1";
            }
            {
              on = "k";
              run = "arrow -1";
            }
            {
              on = "!";
              run = ''shell "$SHELL" --block --confirm'';
              desc = "Open shell here";
            }
            {
              on = "l";
              run = "plugin smart-enter";
              desc = "Enter or open file";
            }
            {
              on = "T";
              run = "plugin toggle-pane max-preview";
              desc = "Maximize preview";
            }
            {
              on = "u";
              run = "plugin restore";
              desc = "Restore last deleted";
            }
            {
              on = "M";
              run = "plugin mount";
              desc = "Mount manager";
            }
            {
              on = [ "g" "t" ];
              run = "cd /home/hojas/.local/share/Trash/files";
              desc = "Goto trash";
            }
            {
              on = [ "<c-n>" ];
              run = ''shell '${pkgs.dragon-drop}/bin/dragon-drop -i -T "$@"' --confirm'';
              desc = "Dragon drop";
            }
            {
              on = [ "g" "n" ];
              run = "cd /home/hojas/.config/nixos/";
              desc = "Go Nixos";
            }
            {
              on = [ "g" "v" ];
              run = "cd /home/hojas/Videos/";
            }
            {
              on = [ "g" "p" ];
              run = "cd /home/hojas/Pictures/";
            }
            {
              on = [ "g" "m" ];
              run = "cd /home/hojas/Music/";
            }
            {
              on = [ "g" "e" ];
              run = "cd /home/hojas/Documents/";
            }
            {
              on = [ "g" "b" ];
              run = "cd /home/hojas/Books/";
            }
            {
              on = [ "." "s" ];
              run = "plugin what-size";
              desc = "Calcular peso";
            }
          ];
        };
      };
    };

    initLua = pkgs.writeText "yazi-init.lua" ''
      Status:children_add(function()
        local h = cx.active.current.hovered
        if h == nil or ya.target_family() ~= "unix" then return ui.Line {} end
        return ui.Line {
          ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
          ui.Span(":"),
          ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
          ui.Span(" "),
        }
      end, 500, Status.RIGHT)

      Header:children_add(function()
        if ya.target_family() ~= "unix" then return ui.Line {} end
        return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
      end, 500, Header.LEFT)

      require("full-border"):setup()
      require("git"):setup()
    '';
  };
}
