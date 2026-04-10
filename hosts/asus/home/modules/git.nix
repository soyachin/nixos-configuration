{
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
    };
    settings.alias = {
      s = "status";
    };
  };
}
