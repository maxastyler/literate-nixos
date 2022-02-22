{ stdenv, emacs, rsync, ... }:
stdenv.mkDerivation rec {
  name = "system-source";
  src = builtins.path {
    name = "org-src";
    path = ./.;
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
    ${rsync}/bin/rsync --exclude=README.org --exclude=install-flake --exclude=flake.nix --exclude=system-source.nix ./* $out/src/
  '';
}
