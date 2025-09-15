{ config, pkgs, ...}:

{

  services.mpd = {
    enable = true;
    musicDirectory = "${config.xdg.userDirs.music}";
    network.startWhenNeeded = false; 
    network.listenAddress = "127.0.0.1";

    extraConfig = ''
      # Forzar UTF-8
      filesystem_charset "UTF-8"
      id3v1_encoding "UTF-8"
      
      # Configuración para manejar archivos problemáticos
      auto_update "yes"
      follow_outside_symlinks "yes"
      follow_inside_symlinks "yes"
      
      # Logs detallados para debugging
      log_level "verbose"

      audio_output {
          type "fifo"
          name "my_fifo"
          path "/tmp/mpd.fifo"
          format "44100:16:2"
      }
    '';


  };

}