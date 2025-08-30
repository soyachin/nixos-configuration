
{ config, pkgs, lib, ... }:

{
  programs.ncmpcpp = {
    enable = true;

    mpdMusicDir = config.xdg.userDirs.music;

    settings = {
      mpd_host = "localhost";
      mpd_port = 6600;
      mpd_connection_timeout = 30;
      user_interface = "classic";

    };
  };
}


