{ pkgs, ... }:
{
services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
  publish = {
    enable = true;
    userServices = true;
  };
};

services.printing = {
  enable = true;
  browsing = true; 
  browsedConf = ''
    BrowseDNSSDSubTypes _cups,_print
    BrowseLocalProtocols all
    BrowseRemoteProtocols all
    CreateIPPPrinterQueues All
    BrowseProtocols all
  '';
  drivers = with pkgs; [ 
    cups-filters
    gutenprint 
  ];
};
}
