{ pkgs, unstable, lib, ... }:

let
  # Definimos el entorno de R como una variable que podamos reusar
  my-r-env = unstable.rWrapper.override {
    packages = with unstable.rPackages; [
      dplyr readr janitor ggplot2 jsonlite scales GGally 
      rvest xml2 XML tidyr DescTools DBI RSQLite
    ];
  };

  my-python-env = unstable.python3.withPackages (ps: with ps; [
    numpy matplotlib jupyterlab scikit-learn notebook
    networkx ipykernel nbconvert nbdime sympy
    graphviz pandas pypandoc
  ]);

  positron-custom = unstable.symlinkJoin {
    name = "positron";
    paths = [ unstable.positron-bin ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/positron \
        --prefix PATH : ${lib.makeBinPath [ my-r-env my-python-env unstable.pandoc ]} \
        --set R_HOME ${my-r-env}/lib/R
    '';
  };
in
{
  environment.systemPackages = [
    positron-custom  # El IDE envuelto
    my-r-env         # <--- ESTO hará que 'which R' funcione en tu terminal
    unstable.pandoc  # También útil tenerlo a mano
  ];
}
