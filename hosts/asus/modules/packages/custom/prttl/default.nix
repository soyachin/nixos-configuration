{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname   = "prttl";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-V5PNTevSqBrTLVQRp2e9lWj04hh6tCHNCnjhf1FlGhc=";
  };

  cargoHash = "sha256-Y7yrsz1fUReRcfGQWT2UEGPv4M2HHsTXe85oR5bD2kA=";

  meta = with lib; {
    description  = "Auto formatter for RDF Turtle, optimized for diff minimization";
    homepage     = "https://codeberg.org/elevont/prttl";
    license      = licenses.eupl12;
    mainProgram  = "prttl";
  };
}
