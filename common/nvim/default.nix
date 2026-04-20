{ ... }: {
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins/ui.nix
    ./plugins/treesitter.nix
    ./plugins/lsp.nix
  ];
}
