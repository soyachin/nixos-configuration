let
  keys = import ../../../../common/ssh-keys.nix;
in
{ pkgs, ... }: {
  users.users.hojas = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "bluetooth"
      "wireshark"
      "adbusers"
    ];

    openssh.authorizedKeys.keys = [
      keys.aobaMini
      keys.termux   
    ];
  };
  programs.zsh.enable = true;
}
