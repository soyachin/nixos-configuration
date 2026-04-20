{ lib, ... }:
let
  tmuxEarlyInit = lib.mkOrder 500 ''
    if [[ -z "$TMUX" ]] && [[ $- == *i* ]]; then
       tmux new-session -A -s main
    fi
  '';
in {
  programs.zsh = {
    enable = true;
    shellAliases = {
      maicra =
        "__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia prismlauncher";
      nrs = "sudo nixos-rebuild switch --flake ~/.config/nixos/#asus";
      nrt = "sudo nixos-rebuild test --flake ~/.config/nixos/#asus";
      kvm = "quickemu --vm kali-current.conf --width 1920 --height 1080";
      hkvm = "quickemu --vm kali-current.conf --display none";
      miniup = "sudo nixos-rebuild switch --flake ~/.config/nixos/#mini --sudo --ask-sudo-password";
      nvapp = "__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia ";
    };

    # initContent = tmuxEarlyInit;

    oh-my-zsh = {
      enable = true;
      theme = "bira";
    };

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;
  };
}
