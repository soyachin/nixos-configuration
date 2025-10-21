{
  config,
  pkgs,
  ...
}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };

    gc = {
      options = "--delete-older-than 7d";
    };
  };
}
