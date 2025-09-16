{
 programs.zsh = {
    enable = true;
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/.config/nixos/#asus";
      ccat = "wl-copy <";
      maicra = "__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia prismlauncher"; 
      config = "cd ~/.config/nixos/";
      gs = "git status";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "gh" "themes"];
      theme = "bira";
    };
  };
}
