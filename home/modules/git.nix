{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    aliases = {
      s = "status";
    };

    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
