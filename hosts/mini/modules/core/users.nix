let
  keys = import ../../../../common/ssh-keys.nix;
in
{
  pkgs,
  ...
}:
{
  users.users.aoba = {
    isNormalUser = true;
    description = "aoba";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    openssh.authorizedKeys.keys = [
      keys.hojasAsus
      keys.termux
    ];
  };

  users.users.deploy = {
    isNormalUser = true;
    group = "deploy";
    shell = pkgs.bashInteractive;
    openssh.authorizedKeys.keys = [
      keys.githubActions 
    ];
  };

  users.groups.deploy = { };
}
