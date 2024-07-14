{
  darwin,
  fetchFromGitHub,
  lib,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "trin";
  version = "v0.1.1";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "5f32eb9e704a210d4315b693d8f9798633ffe2fa";
    hash = "sha256-MS8muNKofHn1Nolp6otks9KDBmNuRbKO0owpMmZkKIU";
  };


  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "alloy-consensus-0.1.0" = "sha256-2TZeQo0d+Yp0M46VNx3OZoyDT4F31cLdOpl1tk3syfg=";
      # "discv5-0.4.1" = "sha256-agrluN1C9/pS/IMFTVlPOuYl3ZuklnTYb46duVvTPio=";
      # "revm-inspectors-0.1.0" = "sha256-ZRlYNEHD+wewlttUcMuEoTYg9Hn89JVAr7+hIeMBXog=";
    };
  };

  enableParallelBuilding = true;

  cargoBuildFlags = ["--package trin-web"];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  # `darwin` seems to have issues with jemalloc
  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional (stdenv.system != "x86_64-darwin") "jemalloc";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "An Ethereum portal client: a json-rpc server with nearly instant sync, and low CPU & storage usage";
    homepage = "https://github.com/ethereum/trin";
    license = with licenses; [mit asl20];
    #mainProgram = "trin";
    platforms = ["aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux"];
  };
}
