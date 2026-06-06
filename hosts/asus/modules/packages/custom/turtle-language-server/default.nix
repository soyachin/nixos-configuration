# Comando que espera lspconfig: turtle-language-server --stdio
{
  lib,
  stdenv,
  fetchurl,
  nodejs,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "turtle-language-server";
  version = "3.5.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/turtle-language-server/-/turtle-language-server-${version}.tgz";
    hash = "sha256-Q2kFZIm5R/bZOyaRUutqqPZVP8uPqMSp/DmhDOONGnE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    tar xzf $src --strip-components=1
  '';

  installPhase = ''
    install -Dm755 dist/cli.js $out/lib/turtle-language-server/cli.js

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/turtle-language-server \
      --add-flags "$out/lib/turtle-language-server/cli.js"
  '';

  meta = with lib; {
    description = "LSP server for W3C standard Turtle RDF syntax";
    homepage = "https://github.com/stardog-union/stardog-language-servers";
    license = licenses.asl20;
    mainProgram = "turtle-language-server";
    platforms = platforms.all;
  };
}
