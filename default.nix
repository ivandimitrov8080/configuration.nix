with import <nixpkgs> {};
mkShell {
  buildInputs = [
    python3
    glibc 
    libgccjit
    binutils
    glibc
  ];
}

