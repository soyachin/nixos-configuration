{
  networking.firewall = {
    allowedTCPPorts = [
      22
      22220
      5353
    ];
    allowedUDPPorts = [ 631 ];
  };
}
