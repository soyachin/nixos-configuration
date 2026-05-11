let
  keys = import ../../modules/core/ssh-keys.nix;
in
{ pkgs, ... }:
{
  users.users.aoba = {
    isNormalUser = true;
    description = "aoba";
    extraGroups = [
      "networkmanager"
      "wheel"
      "urbania"
    ];

    openssh.authorizedKeys.keys = [
      keys.hojasAsus
      keys.termux
    ];
  };

  users.users.deploy = {
    isSystemUser = true;
    group = "deploy";
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [ keys.githubActions ];
  };
  users.groups.deploy = { };
}
