{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./zsh.nix
    ./vscodium.nix
    ./sops.nix
    ./git.nix
    ./nvim/default.nix
    ./cava.nix
    ./clock-rs.nix
    ./services
    ./gtk
    ./swaylock
  ];
}
