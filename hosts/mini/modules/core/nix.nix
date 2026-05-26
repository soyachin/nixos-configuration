{ ... }: {
  nix.settings = {
    trusted-users = [ "root" "aoba" ];
    cores = 2;
    substitute = true;
    builders = "";
  };
}
