{
  config,
  lib,
  ...
}: {
  config.scheme = config.nixpkgs.config.scheme;

  /*
  config.theme = {
    font = {
      mono = "ComicShanns Nerd Font Mono";
    };
  };
  */
}
