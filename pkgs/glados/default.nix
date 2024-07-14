{
  darwin,
  fetchFromGitHub,
  lib,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage rec {
  pname = "glados";
  version = "v0.0.1";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "5c7032a8e3f27eb28ada45338e02b7a1f4af1b6d";
    hash = "sha256-wLVZB3+iuAAjZKoR/7dJBFbwBUnzAhIPT6XnQv7sJQg";
  };


  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "eth_trie-0.4.0" = "sha256-h68GZU0Dq2V853d07cY1eyBehhOKM30tujD/iMoAikI=";
      "ethportal-api-0.2.2" = "sha256-hpwi5e+AO1v1sWU4wGatDliZE/P5aEAzNYVhdcclXzo=";
      "reth-rpc-types-0.2.0-beta.5" = "sha256-d1GYnmgv/ADJjdp2XqU+klzjnnGY/nPuIsYeSXO3H18=";
      "ssz_types-0.6.0" = "sha256-cYLtVPzl/za17eHPuL+mayHZbudUp/4nns19qP7lsjw=";
      "tree_hash-0.6.0" = "sha256-tbfAN3vURjkH6saS71MvyXhcEjT/GCg2LNiUnVKUtfg=";
      "alloy-consensus-0.1.0" = "sha256-Ayjc/i20YyMxJQXDG2YoW8nbkYGvUZyNkx4OszE/ok0=";
    };
  };

  enableParallelBuilding = true;

  cargoBuildFlags = ["--package glados-monitor --package glados-audit --package glados-web"];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildNoDefaultFeatures = true;
  # `darwin` seems to have issues with jemalloc
  # buildFeatures = lib.optional (stdenv.system != "x86_64-darwin") "jemalloc";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  meta = with lib; {
    description = "Portal network monitoring application.";
    homepage = "https://github.com/ethereum/glados";
    license = with licenses; [mit asl20];
    #mainProgram = "trin";
    platforms = ["aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux"];
  };
}
