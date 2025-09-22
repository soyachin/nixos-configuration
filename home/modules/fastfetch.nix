{
  config,
  pkgs,
  ...
}: {
  programs.fastfetch = {
    enable = true;
    settings = {
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "de"
        "wm"
        "cpu"
        "gpu"
        "memory"
        "disk"
        "break"
        "colors"
      ];
    };
  };
}
