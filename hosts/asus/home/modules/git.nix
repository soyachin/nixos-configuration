{
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
    };
    aliases = {
      s = "status";
    };
  };
}
