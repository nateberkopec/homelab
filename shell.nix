with import <nixpkgs> {};

mkShell { packages = [ kubectl terraform ]; }
