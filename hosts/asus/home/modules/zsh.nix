{pkgs, ...}:
{
 programs.zsh = {
    enable = true;
    shellAliases = {
      maicra = "__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia prismlauncher";  
      nrs = "sudo nixos-rebuild switch --flake ~/.config/nixos/#asus";
      nrt = "sudo nixos-rebuild test --flake ~/.config/nixos/#asus";

    };

    oh-my-zsh = {
      enable = true;
      theme = "bira";
    };

    initExtra = ''
        if [[ -z "$TMUX" ]] && [[ $- == *i* ]]; then
          exec ${pkgs.tmux}/bin/tmux new-session -A -s main
        fi

    '';

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;  
  };
}
