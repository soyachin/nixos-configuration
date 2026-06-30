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
    enableDefaultConfig = false;

    settings = {
      "*" = {
        AddKeysToAgent = "yes";
        Compression = "no";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
        ForwardAgent = "no";
        HashKnownHosts = "no";
        ServerAliveCountMax = 3;
        ServerAliveInterval = 0;
        UserKnownHostsFile = "~/.ssh/known_hosts";
      };

      "github.com" = {
        IdentityFile = "~/.ssh/github_edu_id_ed25519";
        IdentitiesOnly = "yes";
      };

      "mini" = {
        HostName = "100.108.151.5";
        User = "aoba";
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = "yes";
      };
    };
  };
}
