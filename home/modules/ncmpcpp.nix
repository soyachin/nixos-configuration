
{ config, pkgs, lib, ... }:

{
  programs.ncmpcpp = {
    enable = true;

    mpdMusicDir = config.xdg.userDirs.music;

    settings = {
      mpd_host = "localhost";
      mpd_port = 6600;
      
      user_interface = "classic";

    };
  };
}


