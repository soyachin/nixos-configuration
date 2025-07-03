{ config, pkgs, ...}:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-vscode.cpptools
      ms-python.python
      llvm-vs-code-extensions.vscode-clangd
      esbenp.prettier-vscode
      ms-toolsai.jupyter
      ms-toolsai.jupyter-renderers
      dbaeumer.vscode-eslint
      yoavbls.pretty-ts-errors
      jdinhlife.gruvbox
      jnoortheen.nix-ide
    ];
    
    mutableExtensionsDir = false;

    userSettings = {
      "extensions.autoUpdate" = false;
    };
  };

}

