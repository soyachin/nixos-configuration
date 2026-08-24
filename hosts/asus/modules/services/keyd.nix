{ ... }: {
  services.keyd = {
    enable = true;
    keyboards = {
      laptop-internal = {
        ids = [ "0001:0001" ];
        settings = {
          main = {
            capslock = "overload(fix, capslock)";
          };
          "fix" = {
            x = "z";
            a = "s";
          };
        };
      };
    };
  };
}
