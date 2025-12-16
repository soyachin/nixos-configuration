{
  config,
  pkgs,
  ...
}: {
  networking.firewall = {
    allowedTCPPorts = [22 22220];
    allowedUDPPortRanges = [
    { from = 50000; to = 65535; }
  ];
  };
}
