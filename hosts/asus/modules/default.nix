{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./boot
    ./fonts
    ./hardware
    ./network
    ./niri
    ./nvidia
    ./steam
  ];
}
