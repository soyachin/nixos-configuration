{ config, pkgs, lib, hostname, ... }:
{
  environment.sessionVariables = {
    SYSTEMD_PAGER = "";
    SYSTEMD_COLORS = "1";
  } // lib.optionalAttrs (hostname == "mini") {
    TERM = "xterm-256color";
  };

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

    # systemd / journal shortcuts
    ju = "journalctl -u";
    jf = "journalctl -f --no-pager";
    jfu = "journalctl -fu";
    sys = "systemctl";
    srestart = "sudo systemctl restart";
    sstart = "sudo systemctl start";
    logs = "sudo journalctl -xe --no-hostname --no-pager";
    logf = "sudo journalctl -f";
    slog = "sudo journalctl -u";
    services = "systemctl list-units --type=service --state=running";
    failed = "systemctl list-units --failed";

    # Urbania services
    ulist = "systemctl list-units --no-pager --type=service | grep urbania";
    utimer = "systemctl list-timers --no-pager | grep urbania";
    jb = "journalctl -u urbania-backend --no-pager";
    jsc = "journalctl -u urbania-scraper --no-pager -o short-precise";
    jpi = "journalctl -u urbania-pipeline --no-pager -o short-precise";
    jbu = "journalctl -u urbania-backup --no-pager -o short-precise";
    jbw = "journalctl -u urbania-backfill-weekly --no-pager -o short-precise";
    juf = "journalctl -fu urbania-backend --no-pager -o short-precise";
    stb = "systemctl --no-pager status urbania-backend";
    sts = "systemctl --no-pager status urbania-scraper";
    stp = "systemctl --no-pager status urbania-pipeline";
    stbu = "systemctl --no-pager status urbania-backup";
    stbw = "systemctl --no-pager status urbania-backfill-weekly";
    mini-status = "echo '=== TIMERS ===' && systemctl list-timers --no-pager | grep urbania && echo && echo '=== SERVICES ===' && systemctl list-units --no-pager --type=service | grep urbania";

    top = "btop";
    htop = "btop";
    
    rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos/#${hostname}";
  };
}
