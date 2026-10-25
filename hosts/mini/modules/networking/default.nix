{ config, ... }: {
  imports = [
    ../../../../modules/networking
  ];

  sops.secrets.wifi_env = { };

  networking.wireless = {
    enable = true;
    secretsFile = config.sops.secrets.wifi_env.path;
    networks."deco_iceman67".pskRaw = "ext:psk_home";
  };
}
