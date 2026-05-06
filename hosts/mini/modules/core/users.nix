let
  keys = import ../../../../common/ssh-keys.nix;
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
    isSystemUser = true; # CI/CD no necesita ser "usuario normal"
    group = "deploy";
    shell = pkgs.bash; # suficiente para rsync/ssh, sin completion/historial
    openssh.authorizedKeys.keys = [ keys.githubActions ];
  };
  users.groups.deploy = { };
}
