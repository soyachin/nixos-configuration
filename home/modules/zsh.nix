{
 programs.zsh = {
    enable = true;
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/.config/nixos/#nixos";
      ccat = "wl-copy <";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "gh" "themes"];
      theme = "bira";
    };
  };
}
