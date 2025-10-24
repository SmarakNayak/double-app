{
  description = "Minimal Expo app with EAS, Postgres, and Foundry";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    ethereum.url = "github:nix-community/ethereum.nix";
    # foundry.url = "github:shazow/foundry.nix/monthly";  # Alternative: pre-built binaries (requires local solc workaround)
  };

  outputs = { self, nixpkgs, ethereum }:
    let
      forEachSystem = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      devShells = forEachSystem (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.nodejs_24
              pkgs.bun
              pkgs.git
              pkgs.postgresql_18
              ethereum.packages.${system}.foundry
            ];

            shellHook = ''
              echo "Expo + EAS + Postgres + Foundry Environment"
              echo "Platform: ${system}"
              echo "Node: $(node --version)"
              echo "Bun: $(bun --version)"
              echo "Postgres: $(postgres --version)"
              echo "Foundry: $(forge --version | head -n1)"
              echo ""
              echo "Next steps:"
              echo "  1. npm install (or bun install)"
              echo "  2. npx expo start"
              echo "  3. eas build (for cloud builds)"
            '';
          };
        });
    };
}
