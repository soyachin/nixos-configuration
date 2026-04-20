{ config, pkgs, lib, isHeadless ? false, ... }:
let
  # Usar los plugins que ya vienen en nixpkgs si es posible
  plugins = {
    smart-enter = pkgs.yaziPlugins.smart-enter;
    toggle-pane = pkgs.yaziPlugins.toggle-pane;
    restore = pkgs.yaziPlugins.restore;
    mount = pkgs.yaziPlugins.mount;
    git = pkgs.yaziPlugins.git;
    full-border = pkgs.yaziPlugins.full-border;
    what-size = pkgs.fetchFromGitHub {
      owner = "pirafrank";
      repo = "what-size.yazi";
      rev = "main";
      sha256 = "sha256-s2BifzWr/uewDI6Bowy7J+5LrID6I6OFEA5BrlOPNcM=";
    };
  };

  # Configuración compilada a TOML
  yazi-toml = lib.generators.toTOML {
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
      { mime = "text/*"; use = "edit"; }
      { mime = "video/*"; use = "play"; }
    ];
  };

  keymap-toml = ''
    [[manager.prepend_keymap]]
    on = "j"
    run = "arrow 1"

    [[manager.prepend_keymap]]
    on = "k"
    run = "arrow -1"

    [[manager.prepend_keymap]]
    desc = "Open shell here"
    on = "!"
    run = "shell \"$SHELL\" --block --confirm"

    [[manager.prepend_keymap]]
    desc = "Enter or open file"
    on = "l"
    run = "plugin smart-enter"

    [[manager.prepend_keymap]]
    desc = "Maximize preview"
    on = "T"
    run = "plugin toggle-pane max-preview"

    [[manager.prepend_keymap]]
    desc = "Restore last deleted"
    on = "u"
    run = "plugin restore"

    [[manager.prepend_keymap]]
    desc = "Mount manager"
    on = "M"
    run = "plugin mount"

    [[manager.prepend_keymap]]
    desc = "Goto trash"
    on = ["g", "t"]
    run = "cd /home/hojas/.local/share/Trash/files"

    ${lib.optionalString (!isHeadless) ''
    [[manager.prepend_keymap]]
    desc = "Dragon drop"
    on = ["<c-n>"]
    run = "shell 'dragon-drop -i -T \"$@\"' --confirm"
    ''}

    [[manager.prepend_keymap]]
    desc = "Go Nixos"
    on = ["g", "n"]
    run = "cd /home/hojas/.config/nixos/"

    [[manager.prepend_keymap]]
    on = ["g", "v"]
    run = "cd /home/hojas/Videos/"

    [[manager.prepend_keymap]]
    on = ["g", "p"]
    run = "cd /home/hojas/Pictures/"

    [[manager.prepend_keymap]]
    on = ["g", "m"]
    run = "cd /home/hojas/Music/"

    [[manager.prepend_keymap]]
    on = ["g", "e"]
    run = "cd /home/hojas/Documents/"

    [[manager.prepend_keymap]]
    on = ["g", "b"]
    run = "cd /home/hojas/Books/"

    [[manager.prepend_keymap]]
    desc = "Calcular peso"
    on = [".", "s"]
    run = "plugin what-size"
  '';

in {
  environment.systemPackages = [ pkgs.yazi ]
    ++ lib.optionals (!isHeadless) [ pkgs.dragon-drop pkgs.xdg-utils ];

  environment.etc = {
    "xdg/yazi/yazi.toml".text = yazi-toml;
    "xdg/yazi/keymap.toml".text = keymap-toml;
    
    "xdg/yazi/init.lua".text = ''
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

    # Plugins
    "xdg/yazi/plugins/smart-enter.yazi".source = plugins.smart-enter;
    "xdg/yazi/plugins/toggle-pane.yazi".source = plugins.toggle-pane;
    "xdg/yazi/plugins/restore.yazi".source = plugins.restore;
    "xdg/yazi/plugins/mount.yazi".source = plugins.mount;
    "xdg/yazi/plugins/git.yazi".source = plugins.git;
    "xdg/yazi/plugins/full-border.yazi".source = plugins.full-border;
    "xdg/yazi/plugins/what-size.yazi".source = plugins.what-size;
  };
}
