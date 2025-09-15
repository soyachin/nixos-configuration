 {config, pkgs, ...}:
 
 {
 
  programs.cava = {
      enable = true;
      settings = {
        input = {
          method = "fifo";
          source = "/tmp/mpd.fifo";
        };
      };
    };

 }