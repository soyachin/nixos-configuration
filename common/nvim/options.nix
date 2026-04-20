{ ... }: {
  programs.nixvim = {
    globals.mapleader = " ";

    opts = {
      # Folding
      foldmethod = "expr";
      foldexpr = "v:treesitter#foldexpr()";
      foldlevel = 99;

      # UI
      conceallevel = 2;

      # Defaults sensatos (inspirados en NvChad/estándar)
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      cursorline = true;
      scrolloff = 8;
      termguicolors = true;
    };
  };
}
