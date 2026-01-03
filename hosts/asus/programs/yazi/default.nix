{ pkgs, config, ... }:

let
  what-size-src = pkgs.fetchFromGitHub {
    owner = "pirafrank";
    repo = "what-size.yazi";
    rev = "main";
    sha256 = "sha256-RInT2/7eS0+2f2Oit0A1m+76uW0vF0fU6mP0X0X0X0X="; 
  };
in
{
  environment.systemPackages = with pkgs; [
    dragon-drop
    mpv
    neovim
    xdg-utils
  ];

  programs.yazi = {
    enable = true;

    plugins = {
      what-size   = what-size-src;
      mount       = pkgs.yaziPlugins.mount;
      full-border = pkgs.yaziPlugins.full-border;
      smart-enter = pkgs.yaziPlugins.smart-enter;
      toggle-pane = pkgs.yaziPlugins.toggle-pane;
      git         = pkgs.yaziPlugins.git;
      restore     = pkgs.yaziPlugins.restore;     };

    initLua = ''
      -- por Grazen0 @ github
      -- Mostrar user:group en la barra de estado (Derecha)
      Status:children_add(function()
        local h = cx.active.current.hovered
        if h == nil or ya.target_family() ~= "unix" then
          return ui.Line {}
        end
        return ui.Line {
          ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
          ui.Span(":"),
          ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
          ui.Span(" "),
        }
      end, 500, Status.RIGHT)

      -- Mostrar user@host en la cabecera (Izquierda)
      Header:children_add(function()
        if ya.target_family() ~= "unix" then
          return ui.Line {}
        end
        return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
      end, 500, Header.LEFT)

      -- Inicialización de plugins
      require("full-border"):setup()
      require("git"):setup()
    '';

    settings = {
      manager = {
        show_symlink = true;
        linemode = "size";
      };

      opener = {
        play = [ { run = ''mpv "$@"''; orphan = true; for = "unix"; } ];
        edit = [ { run = ''nvim "$@"''; block = true; for = "unix"; } ];
        open = [ { run = ''xdg-open "$@"''; desc = "open"; } ];
      };

      open.prepend_rules = [
        { mime = "text/*"; use = "edit"; }
        { mime = "video/*"; use = "play"; }
      ];

      keymap.manager.prepend_keymap = [
        { on = "j"; run = "arrow 1"; }
        { on = "k"; run = "arrow -1"; }
        
        { on = [ "g" "n" ]; run = "cd ~/.config/nixos/"; desc = "Go Nixos"; }
        { on = [ "g" "v" ]; run = "cd ~/Videos/";        desc = "Go Videos"; }
        { on = [ "g" "p" ]; run = "cd ~/Pictures/";      desc = "Go Pictures"; }
        { on = [ "g" "m" ]; run = "cd ~/Music/";         desc = "Go Music"; }
        { on = [ "g" "e" ]; run = "cd ~/Documents/";     desc = "Go Docs"; }
        { on = [ "g" "b" ]; run = "cd ~/Books/";         desc = "Go Books"; }
        { on = [ "g" "t" ]; run = "cd /home/tu_usuario/.local/share/Trash/files"; desc = "Goto trash"; }

        { on = "!"; run = ''shell "$SHELL" --block --confirm''; desc = "Open shell here"; }
        { on = "<c-n>"; run = ''shell '${pkgs.dragon-drop}/bin/dragon-drop -i -T "$@"' --confirm''; desc = "Dragon drop"; }

        # Plugins
        { on = "." "s"; run = "plugin what-size";    desc = "Calcular peso"; }
        { on = "l";     run = "plugin smart-enter";  desc = "Enter child or open file"; }
        { on = "T";     run = "plugin toggle-pane max-preview"; desc = "Maximize preview"; }
        { on = "u";     run = "plugin restore";      desc = "Restore last deleted"; }
        { on = "M";     run = "plugin mount";        desc = "Mount manager"; }
      ];
    };
  };
}
