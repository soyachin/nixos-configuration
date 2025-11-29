{
 programs.zsh = {
    enable = true;
    shellAliases = {
      maicra = "__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia prismlauncher"; 
    };
    oh-my-zsh = {
      enable = true;
      theme = "bira";
    };

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;  
  };
}
