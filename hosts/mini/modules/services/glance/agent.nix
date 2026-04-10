{ pkgs, ... }:
let
  version = "0.1.0";
  glance-agent = pkgs.stdenv.mkDerivation {
    pname = "glance-agent";
    inherit version;
    src = pkgs.fetchurl {
      # nix-prefetch-url https://github.com/glanceapp/agent/releases/download/v0.1.0/agent-linux-amd64.tar.gz  
      url = "https://github.com/glanceapp/agent/releases/download/v${version}/agent-linux-amd64.tar.gz";
      sha256 = "0bjnwv84csfi65x6mrpx0hdi9n1d7xgffcs8g2z78ab6zpglg8ba";
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
    after = [ "network.target" ]; # esperar a q la red esté lista
    wantedBy = [ "multi-user.target" ]; # q se inicie al arrancar
    serviceConfig = {
      ExecStart = "${glance-agent}/bin/glance-agent";
      Restart = "always"; # si falla, se reinicia
      DynamicUser = true; # corre como usuario sin privilegios
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ]; # solo IPv4 e IPv6
      CapabilityBoundingSet = ""; # sin permisos extra
      NoNewPrivileges = true; # no puede obtener privilegios
    };
  };
}
