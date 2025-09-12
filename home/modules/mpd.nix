{ config, pkgs, ...}:

{

services.mpd = {
  enable = true;
  musicDirectory = "/home/${config.user.name}/Música";
  # Optional:
  network.listenAddress = "localhost";
  network.startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
};

}