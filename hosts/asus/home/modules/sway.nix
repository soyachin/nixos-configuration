{ pkgs, ... }:
{
  home.packages = [ pkgs.autotiling ];

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    config = {
      output = {
        "eDP-1" = {
          mode = "1920x1080@144Hz";
          position = "0 0";
          scale = "1";
        };
        "HDMI-A-1" = {
          mode = "1920x1080@60Hz";
          position = "1920 0";
          scale = "1";
        };
      };

      defaultWorkspace = "1";
      bars = [ ];
      workspaceOutputAssign = [
        {
          workspace = "1";
          output = "eDP-1";
        }
        {
          workspace = "2";
          output = "eDP-1";
        }
        {
          workspace = "3";
          output = "eDP-1";
        }
        {
          workspace = "4";
          output = "eDP-1";
        }
        {
          workspace = "5";
          output = "eDP-1";
        }
        {
          workspace = "6";
          output = "HDMI-A-1";
        }
        {
          workspace = "7";
          output = "HDMI-A-1";
        }
        {
          workspace = "8";
          output = "HDMI-A-1";
        }
        {
          workspace = "9";
          output = "HDMI-A-1";
        }
      ];

      startup = [
        { command = "swaybg --image /home/hojas/Pictures/Waterhouse_Echo_and_Narcissus_wall.jpg"; }
        {
          command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway GTK_THEME=Gruvbox-Dark";
        }
        {
          command = "noctalia-shell > /tmp/noctalia.log 2>&1";
          always = true;
        }
        {
          command = "autotiling";
          always = true;
        }
        { command = "swaymsg focus output eDP-1"; }
      ];

      input = {
        "type:keyboard" = {
          xkb_layout = "latam";
          xkb_numlock = "enabled";
        };
        "type:touchpad" = {
          tap = "enabled";
          dwt = "enabled";
          natural_scroll = "disabled";
        };
        "type:pointer" = {
          accel_profile = "flat";
          pointer_accel = "0";
        };
      };

      gaps = {
        inner = 1;
        outer = 3;
      };

      window = {
        border = 2;
        titlebar = false;
      };

      floating = {
        border = 2;
        titlebar = false;
      };

      colors = {
        focused = {
          border = "#98971a";
          background = "#98971a";
          text = "#ebdbb2";
          indicator = "#98971a";
          childBorder = "#98971a";
        };
        unfocused = {
          border = "#3C3C51";
          background = "#3C3C51";
          text = "#a89984";
          indicator = "#3C3C51";
          childBorder = "#3C3C51";
        };
        focusedInactive = {
          border = "#3C3C51";
          background = "#3C3C51";
          text = "#a89984";
          indicator = "#3C3C51";
          childBorder = "#3C3C51";
        };
      };

      focus = {
        wrapping = "no";
      };

      modifier = "Mod4";

      keybindings =
        let
          mod = "Mod4";
          left = "h";
          down = "j";
          up = "k";
          right = "l";
        in
        {
          "${mod}+t" = "exec kitty";
          "${mod}+d" = "exec rofi -show drun";
          "${mod}+Alt+l" = "exec swaylock";
          "${mod}+Alt+f" = "exec auto-f-skip";
          "${mod}+space" = "exec tmux-session-picker";
          "Alt+Tab" = "exec rofi -show window";

          "${mod}+Alt+comma" = "exec noctalia-shell ipc call settings toggle";
          "${mod}+p" = "exec noctalia-shell ipc call bar toggle";
          "${mod}+Shift+r" = "exec killall noctalia-shell; noctalia-shell > /tmp/noctalia.log 2>&1";

          "${mod}+s" =
            "exec echo -e '󰍃 Logout\\n󰜉 Reboot\\n󰐥 Shutdown' | rofi -dmenu -p 'Power' -theme-str 'window {width: 10em; height: 15%;} listview {lines: 3;} inputbar { enabled: false; }' | xargs -I{} sh -c 'case \"{}\" in *Logout*) swaymsg exit ;; *Reboot*) systemctl reboot ;; *Shutdown*) systemctl poweroff ;; esac'";

          "XF86AudioRaiseVolume" = "exec noctalia-shell ipc call volume increase";
          "XF86AudioLowerVolume" = "exec noctalia-shell ipc call volume decrease";
          "XF86AudioMute" = "exec noctalia-shell ipc call volume muteOutput";
          "XF86AudioMicMute" = "exec noctalia-shell ipc call volume muteInput";
          "XF86MonBrightnessUp" = "exec noctalia-shell ipc call brightness increase";
          "XF86MonBrightnessDown" = "exec noctalia-shell ipc call brightness decrease";

          "${mod}+q" = "kill";
          "${mod}+v" = "floating toggle";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+Shift+f" = "fullscreen toggle";
          "${mod}+c" = "move position center";
          "${mod}+Shift+p" = "exec swaymsg output '*' power off";

          "${mod}+${left}" = "focus left";
          "${mod}+${down}" = "focus down";
          "${mod}+${up}" = "focus up";
          "${mod}+${right}" = "focus right";
          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          "${mod}+Ctrl+${left}" = "move left";
          "${mod}+Ctrl+${down}" = "move down";
          "${mod}+Ctrl+${up}" = "move up";
          "${mod}+Ctrl+${right}" = "move right";
          "${mod}+Ctrl+Left" = "move left";
          "${mod}+Ctrl+Down" = "move down";
          "${mod}+Ctrl+Up" = "move up";
          "${mod}+Ctrl+Right" = "move right";

          "${mod}+comma" = "focus output left";
          "${mod}+period" = "focus output right";
          "${mod}+Shift+comma" = "move container to output left; focus output left";
          "${mod}+Shift+period" = "move container to output right; focus output right";

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";

          "${mod}+Ctrl+1" = "move container to workspace number 1";
          "${mod}+Ctrl+2" = "move container to workspace number 2";
          "${mod}+Ctrl+3" = "move container to workspace number 3";
          "${mod}+Ctrl+4" = "move container to workspace number 4";
          "${mod}+Ctrl+5" = "move container to workspace number 5";
          "${mod}+Ctrl+6" = "move container to workspace number 6";
          "${mod}+Ctrl+7" = "move container to workspace number 7";
          "${mod}+Ctrl+8" = "move container to workspace number 8";
          "${mod}+Ctrl+9" = "move container to workspace number 9";

          "${mod}+Page_Down" = "workspace next";
          "${mod}+Page_Up" = "workspace prev";
          "${mod}+i" = "workspace next";
          "${mod}+u" = "workspace prev";
          "${mod}+Ctrl+Page_Down" = "move container to workspace next";
          "${mod}+Ctrl+Page_Up" = "move container to workspace prev";
          "${mod}+Ctrl+i" = "move container to workspace next";
          "${mod}+Ctrl+u" = "move container to workspace prev";

          "${mod}+button5" = "workspace next";
          "${mod}+button4" = "workspace prev";

          "${mod}+r" = "mode resize";

          "${mod}+w" = "layout toggle tabbed splith splitv";
          "${mod}+Tab" = "focus next sibling";
          "${mod}+Shift+Tab" = "focus prev sibling";

          "Print" = "exec grimshot copy area";
          "${mod}+Shift+s" = "exec grimshot save area";
          "Ctrl+Print" = "exec grimshot copy screen";
          "Alt+Print" = "exec grimshot copy active";

          "${mod}+Shift+e" = "exit";
          "Ctrl+Alt+Delete" = "exit";
        };

      modes = {
        resize = {
          "h" = "resize shrink width 20px";
          "l" = "resize grow width 20px";
          "k" = "resize shrink height 20px";
          "j" = "resize grow height 20px";
          "Left" = "resize shrink width 20px";
          "Right" = "resize grow width 20px";
          "Up" = "resize shrink height 20px";
          "Down" = "resize grow height 20px";
          "KP_Add" = "resize grow width 100px";
          "KP_Subtract" = "resize shrink width 100px";
          "Shift+KP_Add" = "resize shrink height 100px";
          "Shift+KP_Subtract" = "resize grow height 100px";
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      };
    };
    extraConfig = ''
      include /etc/sway/config.d/*
      seat seat0 {
        xcursor_theme macOS 24
      }
    '';
  };
  systemd.user.services.gnome-keyring = {
    Unit = {
      Description = "GNOME Keyring daemon";
      PartOf = [ "graphical-session-pre.target" ];
      Before = [ "graphical-session-pre.target" ];
    };
    Service = {
      ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --foreground --components=pkcs11,secrets";
      Restart = "on-abort";
    };
    Install.WantedBy = [ "graphical-session-pre.target" ];
  };
}
