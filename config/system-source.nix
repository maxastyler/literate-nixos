{ stdenv, emacs, rsync, lib, ... }:
let
  dir_filter = path: type: lib.hasSuffix ".org" path;
in stdenv.mkDerivation rec {
  name = "system-source";
  src = builtins.path {
    name = "org-src";
    path = ./.;
    filter = dir_filter;
  };
  buildPhase = ''
    ${emacs}/bin/emacs -Q --batch --eval "
        (progn
          (require 'ob-tangle)
          (dolist (file command-line-args-left)
            (with-current-buffer (find-file-noselect file)
              (org-babel-tangle))))
      " "README.org"
      '';
  installPhase = ''
    mkdir -p $out/src
    ${rsync}/bin/rsync -r --exclude=README.org --exclude=install-flake --exclude=flake.nix --exclude=flake.lock --exclude=system-source.nix ./* $out/src/
  '';
}
