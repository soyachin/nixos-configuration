{ config, pkgs, ...}:

{

  services.mpd = {
    enable = true;
    musicDirectory = "${config.xdg.userDirs.music}";
    # Optional:
    network.listenAddress = "localhost";
    network.startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
  };

}