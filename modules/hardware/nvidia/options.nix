{ lib, ... }: {
  options.platform.hardware.nvidia = {
    enable = lib.mkEnableOption "NVIDIA GPU configuration with PRIME support";
  };
}
