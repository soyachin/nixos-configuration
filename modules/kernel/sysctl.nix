{ lib, ... }: {
  # Defaults de sysctl sobreescribibles por el host
  boot.kernel.sysctl = lib.mkDefault {
    # Valores por defecto vacíos; el host puede extender
  };
}
