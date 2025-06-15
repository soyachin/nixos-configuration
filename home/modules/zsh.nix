{ config, pkgs, ... }:

{

 programs.zsh = {
    enable = true;
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/.nixos-config#nixos";
      nconfig = "sudoedit /etc/nixos/configuration.nix";
      nhome = "sudoedit /etc/nixos/home/main-user.nix";
      ccat = "wl-copy <";
      cdh = "cd /etc/nixos/home/";

    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "gh" "themes"];
      theme = "bira";
    };
  };
}
