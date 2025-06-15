{ config, inputs, ... }:

{
  sops = {
    defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
    age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/sops_ed25519" ];

    secrets = {
      "mopidy/spotify_client_id" = { };
      "mopidy/spotify_client_secret" = { };
    };
  };
}

