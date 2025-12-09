{
  config,
  pkgs,
  ...
}: {
  networking.firewall = {
    allowedTCPPorts = [22];
    allowedUDPPortRanges = [
    { from = 50000; to = 65535; }
  ];
  };
}
