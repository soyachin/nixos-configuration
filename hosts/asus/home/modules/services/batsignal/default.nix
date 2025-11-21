{
  config,
  pkgs,
  ...
}: {
  services.batsignal = {
    enable = true;
    extraArgs = ["-w" "15" "-c" "5" "-p" "-P" "Battery charging :3" "-U" "Battery discharging D:" "-F" "Battery full :D"];
  };
}
