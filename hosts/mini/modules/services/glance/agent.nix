{ pkgs, ... }:
let
  version = "0.1.0";
  glance-agent = pkgs.stdenv.mkDerivation {
    pname = "glance-agent";
    inherit version;
    src = pkgs.fetchurl {
      url = "https://github.com/glanceapp/agent/releases/download/v${version}/agent-linux-amd64.tar.gz";
      sha256 = "1lgxxywqk976zch8710w0bb1i3fv75ilc0w9mgyjznmch8vmlq5q";
    };
    nativeBuildInputs = [ pkgs.installShellFiles ];
    unpackPhase = "tar -xzf $src";
    installPhase = ''
      mkdir -p $out/bin
      cp agent $out/bin/glance-agent
    '';
  };
in
{
  systemd.services.glance-agent = {
    description = "Glance Agent Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${glance-agent}/bin/glance-agent run";
      Restart = "always";
      DynamicUser = true;
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      CapabilityBoundingSet = "";
      NoNewPrivileges = true;
    };
  };
}
