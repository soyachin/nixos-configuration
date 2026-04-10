{ ... }: {
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PermitRootLogin = "no";
      AllowUsers = [ "hojas" ];
      PasswordAuthentication = false;
    };
  };
}
