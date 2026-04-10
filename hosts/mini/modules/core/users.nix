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
      # keys.aobaMini # TODO: Definir en common/ssh-keys.nix
      # keys.termux   # TODO: Definir en common/ssh-keys.nix
    ];
  };
}
