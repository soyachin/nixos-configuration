{ pkgs, unstable, lib, ... }:

let
  # 1. Entorno de R con tus librerías
  my-r-env = unstable.rWrapper.override {
    packages = with unstable.rPackages; [
      dplyr readr janitor ggplot2 jsonlite scales GGally 
      rvest xml2 XML tidyr DescTools
    ];
  };

  # 2. Entorno de Python con tus librerías
  my-python-env = unstable.python3.withPackages (ps: with ps; [
    numpy matplotlib jupyterlab scikit-learn notebook
    networkx ipykernel nbconvert nbdime pandoc sympy
    graphviz pandas
  ]);

  # 3. El Wrapper de Positron
  positron-custom = unstable.symlinkJoin {
    name = "positron";
    paths = [ unstable.positron-bin ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/positron \
        --prefix PATH : ${lib.makeBinPath [ my-r-env my-python-env ]}
    '';
  };
in
{
  environment.systemPackages = [
    positron-custom
  ];

  # Opcional: Asegurar el permiso unfree específicamente para este binario
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "positron-bin"
  ];
}
