{ config, pkgs, ... }:
let
  what-size-src = pkgs.fetchFromGitHub {
    owner = "pirafrank";
    repo = "what-size.yazi";
    rev = "main";
    sha256 = "sha256-s2BifzWr/uewDI6Bowy7J+5LrID6I6OFEA5BrlOPNcM=";
  };
in {
  home.packages = with pkgs; [ dragon-drop xdg-utils ];

  programs.yazi = {
    enable = true;

    plugins = {
      what-size = what-size-src;
      mount = pkgs.yaziPlugins.mount;
      full-border = pkgs.yaziPlugins.full-border;
      smart-enter = pkgs.yaziPlugins.smart-enter;
      toggle-pane = pkgs.yaziPlugins.toggle-pane;
      git = pkgs.yaziPlugins.git;
      restore = pkgs.yaziPlugins.restore;
    };

    initLua = ''
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

    settings = {
      manager = {
        show_symlink = true;
        linemode = "size";
      };
      opener = {
        play = [{
          run = ''mpv "$@"'';
          orphan = true;
          for = "unix";
        }];
        edit = [{
          run = ''nvim "$@"'';
          block = true;
          for = "unix";
        }];
        open = [{
          run = ''xdg-open "$@"'';
          desc = "open";
        }];
      };
      open.prepend_rules = [
        {
          mime = "text/*";
          use = "edit";
        }
        {
          mime = "video/*";
          use = "play";
        }
      ];
    };

    keymap = {
      manager.prepend_keymap = [
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
          run = "cd ${config.home.homeDirectory}/.local/share/Trash/files";
          desc = "Goto trash";
        }
        {
          on = [ "<c-n>" ];
          run = ''shell 'dragon-drop -i -T "$@"' --confirm'';
          desc = "Dragon drop";
        }
        {
          on = [ "g" "n" ];
          run = "cd ${config.home.homeDirectory}/.config/nixos/";
          desc = "Go Nixos";
        }
        {
          on = [ "g" "v" ];
          run = "cd ${config.home.homeDirectory}/Videos/";
        }
        {
          on = [ "g" "p" ];
          run = "cd ${config.home.homeDirectory}/Pictures/";
        }
        {
          on = [ "g" "m" ];
          run = "cd ${config.home.homeDirectory}/Music/";
        }
        {
          on = [ "g" "e" ];
          run = "cd ${config.home.homeDirectory}/Documents/";
        }
        {
          on = [ "g" "b" ];
          run = "cd ${config.home.homeDirectory}/Books/";
        }
        {
          on = [ "." "s" ];
          run = "plugin what-size";
          desc = "Calcular peso";
        }
      ];
    };
  };
}
