{
  description = "Minimal Expo app with EAS, Postgres, and Foundry";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    ethereum.url = "github:nix-community/ethereum.nix";
    android-nixpkgs.url = "github:tadfisher/android-nixpkgs";
    # foundry.url = "github:shazow/foundry.nix/monthly";  # Alternative: pre-built binaries (requires local solc workaround)
  };

  outputs = { self, nixpkgs, ethereum, android-nixpkgs }:
    let
      forEachSystem = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      devShells = forEachSystem (system:
        let
          pkgs = import nixpkgs { inherit system; };

          # Configure Android SDK with emulator
          androidSdk = android-nixpkgs.sdk.${system} (sdkPkgs: with sdkPkgs; [
            cmdline-tools-latest
            build-tools-35-0-0
            platform-tools
            platforms-android-35
            emulator
            system-images-android-35-google-apis-x86-64
            system-images-android-35-google-apis-arm64-v8a
          ]);
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.nodejs_24
              pkgs.bun
              pkgs.git
              pkgs.postgresql_18
              androidSdk
              ethereum.packages.${system}.foundry
            ];

            shellHook = ''
              export ANDROID_HOME="${androidSdk}/share/android-sdk"
              export ANDROID_SDK_ROOT="${androidSdk}/share/android-sdk"

              echo "Expo + EAS + Postgres + Foundry + Android Environment"
              echo "Platform: ${system}"
              echo "Node: $(node --version)"
              echo "Bun: $(bun --version)"
              echo "Postgres: $(postgres --version)"
              echo "Foundry: $(forge --version | head -n1)"
              echo "Android SDK: $ANDROID_HOME"
              echo ""
              echo "Next steps:"
              echo "  1. cd mobile && bun install"
              echo "  2. bun run android (uses emulator)"
              echo "  3. eas build (for cloud builds)"
              echo ""

              # Launch the shell you were actually using
              parent_shell=$(ps -p $PPID -o comm= 2>/dev/null || echo "unknown")
              if echo "$parent_shell" | grep -q "fish"; then
                exec fish
              elif echo "$parent_shell" | grep -q "zsh"; then
                exec zsh
              fi
            '';
          };
        });
    };
}
