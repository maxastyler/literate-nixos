{
  description =
    "Use this flake to generate a configuration based on the README.org file";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    system-source = {
      url = "../";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
  };
  outputs = { self, nixpkgs, home-manager, emacs-overlay, system-source, ... }@attrs: {
    nixosConfigurations.cheeky-monkey = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ("${system-source}/src/configuration.nix")
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.max =
            import ("${system-source}/src/home-manager.nix");
        }
      ];
    };
  };
}
