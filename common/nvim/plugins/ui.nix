{ ... }: {
  programs.nixvim = {
    # Tema
    colorschemes.gruvbox = {
      enable = true;
      settings = {
        transparent_mode = true; # Opcional, pero común en setups modernos
        terminal_colors = true;
      };
    };

    # Overrides de resaltado
    highlight = {
      Comment = { italic = true; };
      "@comment" = { italic = true; };
    };

    plugins = {
      web-devicons.enable = true;
      telescope.enable = true;
      # Statusline
      lualine = {
        enable = true;
        settings.options.theme = "gruvbox";
      };

      # Tabufline alternativo
      bufferline = {
        enable = true;
        settings.options.offsets = [
          {
            filetype = "NvimTree";
            text = "File Explorer";
            text_align = "left";
            separator = true;
          }
        ];
      };

      # Nvdash alternativo
      dashboard = {
        enable = true;
        settings = {
          theme = "hyper"; # Un tema moderno de dashboard-nvim
          config = {
            header = [
              " ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
              " ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
              " ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
              " ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
              " ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
              " ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
            ];
            shortcut = [
              { desc = "󰊄  Find File";    group = "@property"; action = "lua require('telescope.builtin').find_files()"; key = "f"; }
              { desc = "󰈬  Find Word";    group = "@property"; action = "lua require('telescope.builtin').live_grep()";  key = "w"; }
              { desc = "󰩉  Recent Files"; group = "@property"; action = "lua require('telescope.builtin').oldfiles()";   key = "r"; }
              { desc = "󰈚  New File"; group = "@property"; action = "enew"; key = "n"; }
              { desc = "󰒲  Lazy"; group = "@property"; action = "Lazy"; key = "l"; }
              { desc = "󰚰  Update"; group = "@property"; action = "Lazy update"; key = "u"; }
              { desc = "󰈆  Quit"; group = "@property"; action = "qa"; key = "q"; }
            ];
          };
        };
      };
    };
  };
}
