{config, pkgs, hostname, ...}:

{
  environment.shellAliases = {
    # muchos aliases son sacados de github:Grazen0/nixos-config ee >:]
    sudo = "sudo ";
    t = "tmux";
    gs = "git status";
    gd = "git diff";
    gcl = "git clone";
    ga = "git add";
    ".." = "cd ..";
    ll = "lsd -l";
    la = "lsd -la";
    ls = "lsd";
    gcm = "git commit -m";
    lg = "lazygit";
    md = "mkdir -p"; 
    gp = "git push";
    grep = "grep --color=auto";
    nixc = "cd ~/.config/nixos/";
    v = "nvim";
    nfu = "nix flake update --flake ~/.config/nixos/#${hostname}";
    ngc = "sudo nix-collect-garbage --delete-old && nix-collect-garbage --delete-old";
    e = "exit";
    c = "clear";
    tc = "touch";
    rm = "rmtrash";
    rmfr = "${pkgs.coreutils}/bin/rm";
    cp = "cp -i";
    mv = "mv -i";

  };
}
