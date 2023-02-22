{
  outputs = { self, nixpkgs, ... }@inputs: let
    dmr-utils3 = pkgs: pkgs.python3Packages.buildPythonPackage {
      pname = "dmr_utils3";
      version = "0.1.29";
      src = ./.;
      propagatedBuildInputs = with pkgs.python3Packages; [
        bitstring
        bitarray
      ];
      doCheck = false;
      pythonCheckImports = [ "dmr_utils3" ];
    };
    python-env = pkgs: pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
      bitstring
      bitarray
    ]);
  in {
    devShells.x86_64-linux.default = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in pkgs.mkShell {
      buildInputs = [
        (python-env pkgs)
      ];
    };
    packages.x86_64-linux = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in with pkgs; {
      dmr-utils3 = (dmr-utils3 pkgs);
    };
  };
}
