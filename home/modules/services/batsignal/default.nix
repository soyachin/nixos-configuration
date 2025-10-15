{ config, pkgs, ...}:

{
  services.batsignal = {
    enable = true;
    extraArgs = [
      "-l" "15"                    # Low battery threshold
      "-c" "5"                     # Critical battery threshold  
      "-W" "Battery at 15%, charge soon"    # Warning message
      "-C" "Critical battery level: 5%"     # Critical message
      "-F" "Battery full :D"
      "-p"
      "-P" "Battery charging :3"
    ];
  }
}
