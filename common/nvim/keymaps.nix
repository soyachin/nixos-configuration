{ ... }: {
  programs.nixvim = {
    keymaps = [
      # Básicos
      {
        mode = "n";
        key = ";";
        action = ":";
        options.desc = "CMD enter command mode";
      }
      {
        mode = "i";
        key = "jk";
        action = "<ESC>";
        options.desc = "Escape insert mode";
      }

      # Typst Preview
      {
        mode = "n";
        key = "<leader>tp";
        action = "<cmd>TypstPreviewToggle<cr>";
        options.desc = "Typst Preview Toggle";
      }
      {
        mode = "n";
        key = "<leader>ts";
        action = "<cmd>TypstPreviewStop<cr>";
        options.desc = "Typst Preview Stop";
      }
    ];
  };
}
