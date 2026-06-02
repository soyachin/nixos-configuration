{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withRuby = true;
    withPython3 = true;
  };

  environment.systemPackages = with pkgs; [
    git
    tmux
    lazygit
    fastfetch
    htop
    btop
    tree
    nitch
    acpi
    rmtrash
    ffmpeg
    lsd
    ripgrep
    fzf
    bat
    fd
    eza
    zoxide
    unrar
    unzip
    p7zip
    yt-dlp
    wget
    curl
    nodejs_22
    python3
    cargo
    sops
    age
    ntfs3g
    pciutils
    usbutils
    dmidecode
    smartmontools
    lsof
    ethtool
    tcpdump
    nmap
    strace
    procs
    ncdu
    iotop
    lm_sensors
    powertop
    bc
    lldb
    lnav
    grc
    bandwhich
  ];
}
