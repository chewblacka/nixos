{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    disko = { url = "github:nix-community/disko";
              inputs.nixpkgs.follows = "nixpkgs"; };
    impermanence.url = "github:nix-community/impermanence";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    # flake-programs-sqlite = { url = "github:wamserma/flake-programs-sqlite";
    #                           inputs.nixpkgs.follows = "nixpkgs"; };
  };
  outputs = { self, nixpkgs, disko, impermanence, nix-index-database, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; }; # forward inputs to modules
      modules = [ ./configuration.nix
                  # This fixes nixpkgs (for e.g. "nix shell") to match the system nixpkgs
                  ({ config, pkgs, options, ... }: { nix.registry.nixpkgs.flake = nixpkgs; })
                  disko.nixosModules.disko
                  impermanence.nixosModules.impermanence
                  # inputs.flake-programs-sqlite.nixosModules.programs-sqlite
                  nix-index-database.nixosModules.nix-index
                  # optional to also wrap and install comma
                  # { programs.nix-index-database.comma.enable = true; }
                ];
    };
  };
}
