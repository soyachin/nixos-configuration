{ lib, ... }: {
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      AllowUsers = lib.mkDefault [ ];
    };
  };
}
