let
  keys = import ../../../../common/ssh-keys.nix;
in
{ config, ... }: {
  users.users.aoba = {
    isNormalUser = true;
    description = "aoba";
    extraGroups = [ "networkmanager" "wheel" ];

    openssh.authorizedKeys.keys = [
      keys.hojasAsus
      keys.termux   
    ];
  };
}
