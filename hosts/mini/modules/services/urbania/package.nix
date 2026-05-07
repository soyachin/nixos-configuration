# hosts/mini/modules/services/urbania/package.nix
# Entorno Python para Urbania BI.
# curl-cffi requiere binarios compilados que no están en nixpkgs,
# así que usamos un virtualenv gestionado por el servicio en preStart.
# El resto de dependencias vienen de nixpkgs para reproducibilidad.
{ pkgs }:

pkgs.python3.withPackages (ps: with ps; [
  # Scraper
  sqlalchemy
  pandas
  requests
  geopandas
  shapely
  overpy

  # Pipeline / DB
  duckdb

  # Backend
  fastapi
  uvicorn
  pyjwt
  cryptography

  # Utilidades
  pip        # necesario para instalar curl-cffi en el venv
])
