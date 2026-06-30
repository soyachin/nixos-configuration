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

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };
}
