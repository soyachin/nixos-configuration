{config, pkgs, hostname, ...}:

{
  environment.shellAliases = {
    gs = "git status";
    gd = "git diff";
    gcl = "git clone";
    ga = "git add";
    ".." = "cd ..";
    ll = "lsd -l";
    la = "lsd -la";
    ls = "lsd";
    gcm = "git commit -m";
    gp = "git push";
    # update = "sudo nixos-rebuild switch --flake ~/.config/nixos/#${hostname}";
    # test = "sudo nixos-rebuild test --flake ~/.config/nixos/#${hostname}";
    grep = "grep --color=auto";
    config = "cd ~/.config/nixos/";
  };
}
