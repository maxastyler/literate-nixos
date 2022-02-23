{
  description =
    "Use this flake to generate a configuration based on the README.org file";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    system-source = {
      url = "./config";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
  };
  outputs = { system-source, ... }@attrs:
    let source-folder = system-source.defaultPackage."x86_64-linux";
    in import "${source-folder}/src/build-fun.nix" attrs;
}
