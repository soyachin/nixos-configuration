{
  config,
  pkgs,
  ...
}: {
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = true;
    settings = {
      # workaround for
      # https://github.com/nix-community/home-manager/issues/632
      program_options = {
        # replace with your favorite file manager
        file_manager = "${pkgs.nautilus}/bin/nautlilus";
      };
    };
  };
}
