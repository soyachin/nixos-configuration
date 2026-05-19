# hosts/mini/modules/security/default.nix
# Hardening de red y protección anti-abuso para el servidor mini.
{ pkgs, ... }: {
  imports = [ ./service-limits.nix ];
  # ---------------------------------------------------------------------------
  # fail2ban — banea IPs que abusen de nginx (429s, auth failures)
  # ---------------------------------------------------------------------------
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";

    bantime-increment = {
      enable = true;
      maxtime = "48h";
      factor = "4";
    };

    jails = {
      # Ban IPs que reciben muchos 429 (rate limited by nginx)
      nginx-limit-req.settings = {
        enabled = true;
        filter = "nginx-limit-req";
        logpath = "/var/log/nginx/error.log";
        maxretry = 10;
        findtime = 120;
        bantime = 600;
        action = "iptables-multiport[name=nginx-limit-req, port=\"http,https\", protocol=tcp]";
      };

      # Ban IPs con demasiados 4xx (scanners, bots)
      nginx-botsearch.settings = {
        enabled = true;
        filter = "nginx-botsearch";
        logpath = "/var/log/nginx/access.log";
        maxretry = 10;
        findtime = 120;
        bantime = 600;
        action = "iptables-multiport[name=nginx-botsearch, port=\"http,https\", protocol=tcp]";
      };
    };
  };

  # Nginx necesita escribir logs para que fail2ban los lea
  services.nginx.appendHttpConfig = ''
    error_log /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
  '';

  # ---------------------------------------------------------------------------
  # sysctl — hardening de red contra SYN flood, spoofing, ICMP abuse
  # ---------------------------------------------------------------------------
  boot.kernel.sysctl = {
    # SYN flood protection
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_max_syn_backlog" = 2048;
    "net.ipv4.tcp_synack_retries" = 2;
    "net.ipv4.tcp_syn_retries" = 3;

    # Anti-spoofing (reverse path filtering)
    # Nota: loose mode (2) porque ip_forward=1 para Tailscale
    "net.ipv4.conf.default.rp_filter" = 2;
    "net.ipv4.conf.all.rp_filter" = 2;

    # Ignorar ICMP redirects (previene MITM)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;

    # Rate-limit ICMP
    "net.ipv4.icmp_ratelimit" = 100;
    "net.ipv4.icmp_ratemask" = 88089;

    # Ignore bogus ICMP error responses
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;

    # Log martian packets (for diagnostics)
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.default.log_martians" = 1;

    # Reduce TIME_WAIT connections
    "net.ipv4.tcp_fin_timeout" = 15;

    # Connection tracking limits (anti-DoS)
    "net.netfilter.nf_conntrack_max" = 131072;
  };

  # ---------------------------------------------------------------------------
  # Automatic security updates (solo paquetes, no reboot automático)
  # ---------------------------------------------------------------------------
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "04:00";
    flake = "github:soyachin/nixos-configuration#mini";
  };
}
