# flake-positron.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
          "positron-bin"
        ];
      };
    in {
      packages.x86_64-linux.positronEnv = pkgs.buildEnv {
        name = "positron-env";
        paths = with pkgs; [
          positron-bin
          R
          rPackages.dplyr
          rPackages.readr
          rPackages.janitor
          rPackages.ggplot2
          rPackages.jsonlite
          rPackages.scales
          rPackages.GGally
          rPackages.rvest
          rPackages.xml2
          rPackages.XML
          rPackages.tidyr
          rPackages.DescTools
          (python3.withPackages (ps: with ps; [
            numpy
            matplotlib
            jupyterlab
            scikit-learn
            notebook
            networkx
            ipykernel
            nbconvert
            nbdime
            pandoc
            sympy
            graphviz
            pandas
          ]))
        ];
      };
      
      packages.x86_64-linux.positron = pkgs.symlinkJoin {
        name = "positron";
        paths = [ pkgs.positron-bin pkgs.positronEnv ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/positron \
            --set PATH "${pkgs.positronEnv}/bin:$PATH"
        '';
      };

      apps.x86_64-linux.positron = {
        type = "app";
        program = "${pkgs.positron-bin}/bin/positron";
      };
    };
}