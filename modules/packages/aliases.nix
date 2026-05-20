{ config, pkgs, hostname, ... }:
{
  environment.shellAliases = {
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
    miniup = "nixos-rebuild switch --target-host aoba@mini --flake .#mini --sudo --ask-sudo-password";
    e = "exit";
    c = "clear";
    tc = "touch";
    rm = "rmtrash";
    rmfr = "${pkgs.coreutils}/bin/rm";
    cp = "cp -i";
    mv = "mv -i";
    gtree = "git log --oneline --graph --all --decorate --color";
    glog = "git log --oneline --graph --all --decorate --color";

    urb = "systemctl status urbania-backend";
    urbl = "journalctl -u urbania-backend -f -n 100";
    urbp = "systemctl status urbania-pipeline";
    urbd = "systemctl status urbania-deploy";
    urbstart = "sudo systemctl start urbania-backend";
    urbstop = "sudo systemctl stop urbania-backend";
    urbrestart = "sudo systemctl restart urbania-backend";

    logs = "sudo journalctl -xe --no-hostname";
    logf = "sudo journalctl -f";
    slog = "sudo journalctl -u";
    
    top = "btop";
    htop = "btop";
    services = "systemctl list-units --type=service --state=running";
    failed = "systemctl list-units --failed";
    
    rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos/#${hostname}";
  };
}
