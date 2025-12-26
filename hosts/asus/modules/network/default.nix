{
  config,
  pkgs,
  ...
}: {
  networking.firewall = {
    allowedTCPPorts = [22 22220];
    allowedUDPPortRanges = [
    { from = 49152; to = 65535; }
  ];
  };
}
